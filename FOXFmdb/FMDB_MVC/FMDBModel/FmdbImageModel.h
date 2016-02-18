//
//  FmdbImageModel.h
//  FOXFmdb
//
//  Created by 徐惠雨 on 15/8/7.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *存储
 */

@interface FmdbImageModel : NSObject

@property (nonatomic, copy) NSString *region_id;

@property (nonatomic, copy) NSString *save_path_small;

@property (nonatomic, copy) NSString *save_path_large;

@property (nonatomic, copy) NSString *save_path_middle;

@end
