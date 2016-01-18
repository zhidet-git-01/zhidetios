//
//  YJJRequest.h
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/13.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJJRequest : NSObject

+ (void)requestwithURL:(NSString *)urlString dic:(NSDictionary *)dic complete:(void(^)(NSData *data))success fail:(void(^)(NSError *error))failture;

+ (void)PostrequestwithURL:(NSString *)urlString dic:(NSDictionary *)dic complete:(void(^)(NSData *data))success fail:(void(^)(NSError *error))failture;
@end
