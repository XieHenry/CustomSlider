

#import "YJ_Slider.h"
#import "TipsView.h"


#define ImageSpace 12   //默认图片大小


@interface YJ_Slider() {
    CGFloat _pointX;//滑块的x位置
    CGFloat k_Point;//每个字号需要移动的位置
    
    CGFloat default_Width;//控件的宽度
    CGFloat max_Value;
    CGFloat min_Value;
}

@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIView *defaultView;
@property (strong, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) NSArray *titleArray;

@end



@implementation YJ_Slider


-(instancetype)initWithFrame:(CGRect)frame WithColor:(UIColor *)bgColor  WithMaxValue:(CGFloat)maxValue WithMinValue:(CGFloat)minValue titleArray:(NSArray *)titleArray danwei:(NSString *)danwei {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleArray = titleArray;
        
        default_Width = self.bounds.size.width;
        k_Point = default_Width / (maxValue - minValue);
        self.currentValue = 0;
        
        
        self.defaultView = [[UIView alloc] initWithFrame:CGRectMake(0,(self.bounds.size.height - 4)*0.5,default_Width, 4)];
        self.defaultView.backgroundColor = [UIColor lightGrayColor];
        self.defaultView.userInteractionEnabled = NO;
        [self addSubview:self.defaultView];
        
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(self.defaultView.frame.origin.x, self.defaultView.frame.origin.y, self.defaultView.bounds.size.width,self.defaultView.bounds.size.height)];
        self.selectView.backgroundColor = bgColor;
        self.selectView.userInteractionEnabled = NO;
        [self addSubview:self.selectView];
        
        
        
        for (NSInteger i=0; i<titleArray.count; i++) {
            int index = [[titleArray objectAtIndex:i] intValue];
            CGFloat xx =  (index-min_Value) * k_Point;
            
            UIButton *titleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            titleButton.frame = CGRectMake(xx-5, (self.bounds.size.height - 10)/2, 10, 10);
            titleButton.userInteractionEnabled = NO;
            [titleButton setImage:[UIImage imageNamed:@"slider_nor"] forState:(UIControlStateNormal)];
            titleButton.tag = 500+i;
            [self addSubview:titleButton];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(xx-15, 30, 30, 10);
            titleLabel.text = [NSString stringWithFormat:@"%@%@",[titleArray objectAtIndex:i],danwei];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.backgroundColor = UIColor.redColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.userInteractionEnabled = NO;
            [self addSubview:titleLabel];
        }
        
        
        
        self.currentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (self.bounds.size.height - ImageSpace)/2, ImageSpace, ImageSpace)];
        self.currentBtn.userInteractionEnabled = NO;
        [self.currentBtn setImage:[UIImage imageNamed:@"slider_current"] forState:(UIControlStateNormal)];
        [self addSubview:self.currentBtn];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        
        
        
        // 添加 UIPanGestureRecognizer 手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
                
    }
    return self;
}


-(void)handleTap:(UITapGestureRecognizer *)handleTap  {
    [self changePointX:handleTap];
    int num = _pointX/k_Point+min_Value;
    
    
    num = [self closestValueInArray:self.titleArray toTargetValue:num];
    [self changeValue:num];
    
    self.currentValue = num;

    if (self.block) {
        self.block(num);
    }
    [self refreshSlider];
}


- (int)closestValueInArray:(NSArray *)array toTargetValue:(int)targetValue {
    int closestValue = 0;
    int minDifference = INT_MAX;

    for (NSString *valueString in array) {
        int arrayValue = [valueString intValue];
        int difference = abs(arrayValue - targetValue);

        if (difference < minDifference) {
            minDifference = difference;
            closestValue = arrayValue;
        }
    }
    return closestValue;
}




-(void)handlePan:(UIPanGestureRecognizer *)handlePan {
    [self changePointX:handlePan];
    
    int num = _pointX/k_Point+min_Value;
    self.currentValue = num;
    
    if (self.block) {
        self.block(num);
    }
    [self refreshSlider];
}



-(void)changePointX:(UIGestureRecognizer *)touch{
    CGPoint point = [touch locationInView:self];
    _pointX = point.x;
    
    if (_pointX < self.defaultView.frame.origin.x) {
        _pointX = self.defaultView.frame.origin.x;
    }else if (_pointX > (CGRectGetMaxX(self.defaultView.frame))){
        _pointX = CGRectGetMaxX(self.defaultView.frame);
    }
}




-(void)refreshSlider {
    CGFloat Y = self.defaultView.center.y ;
    
    self.currentBtn.frame = CGRectMake(_pointX,Y,ImageSpace,ImageSpace);
    self.currentBtn.center = CGPointMake(_pointX,self.defaultView.center.y);
    CGRect rect = [self.selectView frame];
    rect.size.width = _pointX;
    self.selectView.frame = rect;
    
    
    NSString *text = [NSString stringWithFormat:@"%d",self.currentValue];
    [[TipsView instance] showText:text targetView:self andX:_pointX-9];
    
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [feedBackGenertor impactOccurred];
    
    
    // 遍历按钮数组，找到需要替换图片的按钮
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        int index = [self.titleArray[i] intValue];
        UIButton *titleButton = [self viewWithTag:500 + i];
        if (self.currentValue > index) {
            [titleButton setImage:[UIImage imageNamed:@"slider_sel"] forState:UIControlStateNormal];
        } else {
            [titleButton setImage:[UIImage imageNamed:@"slider_nor"] forState:UIControlStateNormal];
        }
    }
}






-(void)changeValue:(int)number {
    self.currentValue = number;
    _pointX = (number - min_Value) * k_Point;
    [self refreshSlider];
}


@end
