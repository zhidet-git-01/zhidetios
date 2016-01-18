//
//  ProgressView.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 16/1/14.
//  Copyright © 2016年 刘璐璐. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

+ (UIView *)startRequest{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2 - 50, 100, 100, 100)];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 10;
    view.backgroundColor = wordColor;
    
    //刷新按钮
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 60, 20)];
    [startBtn setTitle:@"正在加载" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:wordSize];
    [view addSubview:startBtn];
    
    //请求中显示小菊花
    UIActivityIndicatorView *_activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(45, 30, 10, 10)];
    [_activity startAnimating];
    _activity.color = [UIColor whiteColor];
    [view addSubview:_activity];
    
    return view;
}

+ (UIButton *)againRequest{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 50, 100, 100, 100)];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 10;
    button.backgroundColor = wordColor;
    
    //刷新按钮
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, 60, 20)];
    [startBtn setTitle:@"点我刷新" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:wordSize];
    [button addSubview:startBtn];
    
    //请求中显示小菊花
    UIActivityIndicatorView *_activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(45, 30, 10, 10)];
    _activity.color = [UIColor whiteColor];
    [_activity stopAnimating];
    [_activity setHidesWhenStopped:NO];
    [button addSubview:_activity];
    
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
