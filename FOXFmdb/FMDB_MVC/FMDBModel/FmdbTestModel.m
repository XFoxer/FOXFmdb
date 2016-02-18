//
//  FmdbTestModel.m
//  FOXFmdb
//
//  Created by 徐惠雨 on 15/8/6.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import "FmdbTestModel.h"
#import "MJExtension.h"
#import "FmdbImageModel.h"


@implementation FmdbTestModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"image":[FmdbImageModel class]};
}
/*
- (instancetype)initWithJsonData:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.placeId = [dict objectForKey:@"id"]?[dict objectForKey:@"id"]:@"";
        self.code = [dict objectForKey:@"code"]?[dict objectForKey:@"code"]:@"";
        self.name = [dict objectForKey:@"name"]?[dict objectForKey:@"name"]:@"";
        self.ename = [dict objectForKey:@"ename"]?[dict objectForKey:@"ename"]:@"";
        self.pid = [dict objectForKey:@"pid"]?[dict objectForKey:@"pid"]:@"";
        self.level = [dict objectForKey:@"level"]?[dict objectForKey:@"level"]:@"";
        self.sort = [dict objectForKey:@"sort"]?[dict objectForKey:@"sort"]:@"";
        self.lat = [dict objectForKey:@"lat"]?[dict objectForKey:@"lat"]:@"";
        self.lng = [dict objectForKey:@"lng"]?[dict objectForKey:@"lng"]:@"";
        self.flag = [dict objectForKey:@"flag"]?[dict objectForKey:@"flag"]:@"";
        self.abbr = [dict objectForKey:@"abbr"]?[dict objectForKey:@"abbr"]:@"";
    }
    return self;
}*/


#pragma mark - LKDB Methods

//重载选择 使用的LKDBHelper （可以不用重载，在init方法中有默认设置，可以在那里统一修改）
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
 *修改属性字段的名称 （别名）
 */
+(void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns
{
    for (int i=0; i<columns.count; i++)
    {
        LKDBProperty* p = [columns objectAtIndex:i];
        if([p.propertyName isEqualToString:@"flag"])
        {
            [helper executeDB:^(FMDatabase *db) {
                NSString* sql = [NSString stringWithFormat:@"update %@ set flag = thing",tableName];
                [db executeUpdate:sql];
            }];
        }
    }
    LKErrorLog(@"your know %@",columns);
}

#pragma mark - 关联表 （从表）

/*插入从表数据
 *property   主表 模型中的属性字段（从表名）
 *return id  返回一个可查询该从表数据的字段（唯一确认）
 */
- (id)userGetValueForModel:(LKDBProperty *)property
{
    if ([property.sqlColumnName isEqualToString:@"image"]) {
        
        if (self.image == nil) {
            return @"";
        }
        
        /*
        [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper){
            
            [self.image enumerateObjectsUsingBlock:^(FmdbImageModel *imageModel,NSUInteger idx,BOOL *stop){
                
                BOOL insertSuccess = [helper insertWhenNotExists:imageModel];
                if (insertSuccess) {
                    [FmdbImageModel insertToDB:imageModel];
                }
                else
                {
                    
                }
            }];
        }];
         */
    }
    
    return nil;
}

/*查询从表数据
 *property  主表模型中的属性字段 （从表名）
 *value     用以查询获取从表数据的字段
 */
- (void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
    if ([property.sqlColumnName isEqualToString:@"image"]) {
        
        self.image = nil;
        
        NSMutableArray *imageArray = [FmdbImageModel searchWithWhere:[NSString stringWithFormat:@""] orderBy:nil offset:0 count:1];
        self.image = imageArray;
    }
}


#pragma mark - FMDB 插入是否完成 （可以省略）

// 将要插入数据库
+(BOOL)dbWillInsert:(NSObject *)entity
{
    LKErrorLog(@"will insert : %@",NSStringFromClass(self));
    return YES;
}

// 已经插入数据库
+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKErrorLog(@"did insert : %@",NSStringFromClass(self));
}

#pragma mark - 设置表结构主键（联合主键）

/*
 *不设主键会有默认的主键rowid,
 */

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"name",@"ename"];
}


@end
