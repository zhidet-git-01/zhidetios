//
//  platformModel.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/8.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface platformModel : NSObject

@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *min;
@property(nonatomic, copy)NSString *max;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *activity;
@property(nonatomic, copy)NSString *info;
@property(nonatomic, copy)NSString *regfound;
@property(nonatomic, copy)NSString *starttime;
@property(nonatomic, copy)NSString *prizeplan;
@property(nonatomic, copy)NSString *companyBack;
@property(nonatomic, copy)NSString *recommendreason;
@property(nonatomic, copy)NSString *logolittler;
@property(nonatomic, copy)NSString *officialsite;
@property(nonatomic, copy)NSString *companyid;
@property NSInteger status;
@property NSInteger online;

@end
