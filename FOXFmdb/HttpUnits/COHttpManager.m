//
//  COHttpManager.m
//  XFOXER  BASE REQUEST
//
//  Created by XFoxer on 15/1/22.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//  封装AFN网络请求工具


#import "COHttpManager.h"
#import "SVProgressHUD.h"
//请求超时时间限定
#define kTimeOut 30

@implementation COHttpManager

/*
 *句柄单例
 */
+ (instancetype)sharedManager
{
    static COHttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[COHttpManager alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self checkNetworkStatus];
    }
    return self;
}

/*
 *检查当前网络状态
 */
- (void)checkNetworkStatus
{
    NSURL *baseURL = [NSURL URLWithString:@"http://apple.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability === %@", AFStringFromNetworkReachabilityStatus(status));
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   [SVProgressHUD showInfoWithStatus:@"无网络连接"];
                });
                
                [operationQueue setSuspended:YES];
            }
            default:
                [operationQueue setSuspended:YES];
                break;
        }
        
    }];
    
    [manager.reachabilityManager startMonitoring];
}


/*
 *Get请求
 */
+ (void)httpGET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"RequestURL === %@",url);
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    httpManager.requestSerializer.timeoutInterval  = kTimeOut;
    
    //设置允许解析片段数据
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [httpManager setResponseSerializer:responseSerializer];
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 2.发送请求
    [httpManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ResponseData === %@",responseObject);
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            NSLog(@"Error === %@", [error description]);
            [[self sharedManager] requestFailureError:error];
        }
    }];
}


/*
 *Post请求
 */
+ (void)httpPOST:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    NSLog(@"RequestURL === %@",url);
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    httpManager.requestSerializer.timeoutInterval  = kTimeOut;
    
    //设置允许解析片段数据
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [httpManager setResponseSerializer:responseSerializer];
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 2.发送请求
    [httpManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"ResponseData === %@",responseObject);
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
            NSLog(@"Error === %@", [error description]);
            [[self sharedManager] requestFailureError:error];
        }
    }];
}

/*
 *Delete请求
 */
+ (void)httpDELETE:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{

    NSLog(@"RequestURL === %@",url);
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    httpManager.requestSerializer.timeoutInterval  = kTimeOut;
    
    //设置允许解析片段数据
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [httpManager setResponseSerializer:responseSerializer];
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    // 2.发送请求
    [httpManager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
    
        NSLog(@"ResponseData === %@",responseObject);
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (failure) {
            failure(error);
            NSLog(@"Error === %@", [error description]);
            [[self sharedManager] requestFailureError:error];
        }
    }];

}

/*
 *统一请求出错处理
 */
- (void)requestFailureError:(NSError *)error
{
    
    NSLog(@"ErrorDesc === %@", [error localizedDescription]);
    NSString *errorMsg = [NSString stringWithFormat:@"%@",[error localizedDescription]];

    if ([errorMsg rangeOfString:@"The request timed out"].length > 0) {
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
    }
    else if ([errorMsg rangeOfString:@"The Internet connection appears to be offline"].length > 0 ||[errorMsg rangeOfString:@"The network connection was lost"].length > 0)
    {
        [SVProgressHUD showInfoWithStatus:@"无网络连接"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请求出错"];
    }
    
}


/*
 *测试服上得url前缀
 */
- (NSString *)DebugUrlPrefix
{
    return @"http://airtest.youyoumob.com/";
}

/*
 *正式服上得url前缀
 */
- (NSString *)FormalUrlPrefix
{
    return @"http://airtest.youyoumob.com/";
}

/*
 *返回访问url前缀
 */
+ (NSString *)URLPrefix
{
    return [[self sharedManager] FormalUrlPrefix];
}


@end
