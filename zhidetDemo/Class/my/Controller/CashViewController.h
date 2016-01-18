//
//  CashViewController.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/15.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "BasicController.h"

@interface CashViewController : BasicController

@property(nonatomic, copy)NSString *token;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, copy)NSString *userName;
@property NSInteger payid;
@property(nonatomic, copy)NSString *money;

@end
