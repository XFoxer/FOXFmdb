//
//  LKBaseModel.m
//  FOXFmdb
//
//  Created by 徐惠雨 on 15/8/6.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import "LKBaseModel.h"

@implementation LKBaseModel

/*
 *重载选择 使用的LKDBHelper 设置DB路径
 */
+ (LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"FOX/FOX_LK.db"];
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
    });
    return db;
}


/*
 *将数据模型插入数据库
 */
- (void)insertSelfToDB
{
    
    //启用事物插入
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper){
        
        BOOL isExist = [[LKDBHelper getUsingLKDBHelper] isExistsModel:self];
        
        // 如果存在就直接刷新
        if (isExist) {
            [[LKDBHelper getUsingLKDBHelper] updateToDB:self where:nil];
        }
        // 不存在就直接插入数据库
        else
        {
            [[LKDBHelper getUsingLKDBHelper] insertToDB:self];
        }
        return YES;
    }];
    
   
}

//主键 （给子类重载使用）
+ (NSString *)getPrimaryKey
{
    return nil;
}
///复合主键  这个优先级最高  （给子类重载使用）
+ (NSArray *)getPrimaryKeyUnionArray
{
    return nil;
}
//表名  （给子类重载使用）
+ (NSString *)getTableName
{
    return nil;
}


@end
