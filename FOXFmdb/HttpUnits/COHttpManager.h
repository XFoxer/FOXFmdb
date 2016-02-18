//
//  COHttpManager.h
//  XFOXER  BASE REQUEST
//
//  Created by XFoxer on 15/1/22.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//  封装AFN网络请求

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface COHttpManager : NSObject

/*
 *Get请求
 */
+ (void)httpGET:(NSString *)url
         params:(NSDictionary *)params
        success:(void (^)(id json))success
        failure:(void (^)(NSError *error))failure;

/*
 *Post请求
 */
+ (void)httpPOST:(NSString *)url
          params:(NSDictionary *)params
         success:(void (^)(id json))success
         failure:(void (^)(NSError *error))failure;

/*
 *Delete请求
 */
+ (void)httpDELETE:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id json))success
           failure:(void (^)(NSError *error))failure;


/*
 *RequestUrl前缀
 */
+ (NSString *)URLPrefix;


@end
