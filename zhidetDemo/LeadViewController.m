//
//  LeadViewController.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/4.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "LeadViewController.h"
#import "AppDelegate.h"
#import "BasicTabBarController.h"

@interface LeadViewController ()

@end

@implementation LeadViewController
{
    UIScrollView *_scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatGuide];
    
}

-(void)creatGuide
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    _scrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    
    
    _scrollView.pagingEnabled = YES;
    _scrollView.indicatorStyle =UIScrollViewIndicatorStyleWhite;
    _scrollView.bounces = NO;
    //通过循环给滚动视图添加图片
    for (int i = 0; i < 3; i++) {
        UIButton *iv = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [iv setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i + 1]] forState:UIControlStateNormal];
        [_scrollView addSubview:iv];
        
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 120, HEIGHT - 100, 100, 40)];
            button.layer.cornerRadius = 6;
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 2;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"开始体验" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(toStart:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            [iv addSubview:button];
    }
    [self.view addSubview:_scrollView];
    // [self.window addSubview:_scrollView];
    // [userDefault setBool:YES forKey:@"isFirsS"];
    
}
- (void) toStart:(UIButton *)sender{
    [_scrollView removeFromSuperview];
    // 创建tabBarVc
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    BasicTabBarController *tabBarVc = [[BasicTabBarController alloc] init];
    app.window.rootViewController = tabBarVc;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
