//
//  FmdbTestModel.h
//  FOXFmdb
//
//  Created by 徐惠雨 on 15/8/6.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"



@interface FmdbTestModel : NSObject


@property (nonatomic, copy) NSString *placeId;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *abbr;

@property (nonatomic, copy) NSArray *image;


/*
 *给Test 模态赋值
 */
- (instancetype)initWithJsonData:(NSDictionary *)dict;

@end
