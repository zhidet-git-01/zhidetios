//
//  CLLockLabel.h
//  ShouShiJieSuo
//
//  Created by 张策 on 15/12/3.
//  Copyright © 2015年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLockLabel : UILabel



/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;



/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;


@end
