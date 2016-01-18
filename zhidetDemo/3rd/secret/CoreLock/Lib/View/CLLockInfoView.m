//
//  CLLockInfoView.m
//  ShouShiJieSuo
//
//  Created by 张策 on 15/12/3.
//  Copyright © 2015年 ZC. All rights reserved.
//

#import "CLLockInfoView.h"
#import "CoreLockConst.h"

@implementation CLLockInfoView

-(void)awakeFromNib{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80 , 80);
    [button setBackgroundImage:[UIImage imageNamed:@"white-tou"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 40;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(setUserImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    NSLog(@"加载");
}

- (void)setUserImage:(UIButton *)send
{
    
}


















@end
