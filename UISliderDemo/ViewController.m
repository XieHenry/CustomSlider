//
//  ViewController.m
//  UISliderDemo
//
//  Created by henry on 2023/12/6.
//


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#import "ViewController.h"
#import "YJ_Slider.h"


@interface ViewController () 


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0,50,SCREEN_WIDTH,30)];
    titleLable.text = @"0";
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont systemFontOfSize:20];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    
    
    
    NSArray *titlesArray = @[@"1",@"25",@"50",@"75",@"100"];
    YJ_Slider *slider = [[YJ_Slider alloc]initWithFrame:CGRectMake(50, 100,SCREEN_WIDTH-100, 20) WithColor:[UIColor redColor] WithMaxValue:100 WithMinValue:0 titleArray:titlesArray danwei:@"X"];
    slider.backgroundColor = UIColor.greenColor;
    slider.block = ^(int value){
//        NSLog(@"选中的值是：%d",value);
        titleLable.text = [NSString stringWithFormat:@"%d",value];
    };
    [self.view addSubview:slider];
}



@end
