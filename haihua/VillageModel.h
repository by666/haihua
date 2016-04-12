//
//  VillageModel.h
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VillageModel : NSObject

//小区id
@property (assign, nonatomic) int villageId;

//小区名称
@property (copy, nonatomic) NSString *name;

//小区地址
@property (copy, nonatomic) NSString *address;


@end
