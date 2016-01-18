//
//  YJJRequest.m
//  zhidetDemo
//
//  Created by 刘璐璐 on 15/12/13.
//  Copyright © 2015年 刘璐璐. All rights reserved.
//

#import "YJJRequest.h"
#import <AFNetworking.h>

@implementation YJJRequest

+ (void)requestwithURL:(NSString *)urlString dic:(NSDictionary *)dic complete:(void (^)(NSData *))success fail:(void (^)(NSError *))failture{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failture(error);
    }];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failture(error);
//    }];
}

//post请求
+ (void)PostrequestwithURL:(NSString *)urlString dic:(NSDictionary *)dic complete:(void (^)(NSData *))success fail:(void (^)(NSError *))failture{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failture(error);
    }];
    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        success(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        failture(error);
//        
//    }];
}

@end
