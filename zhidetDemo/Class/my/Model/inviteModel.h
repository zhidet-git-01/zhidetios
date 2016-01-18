//
//  inviteModel.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/29.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface inviteModel : NSObject

@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *createttime;
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *inviteUrl;
@property NSInteger status;
@property NSInteger inviteID;

@end
