//
//  PictureModel.h
//  haihua
//
//  Created by by.huang on 16/4/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject


@property (assign, nonatomic) int pid;

@property (assign, nonatomic) int type;

@property (copy, nonatomic) NSString *data;

@property (assign, nonatomic) int pic;
@end
