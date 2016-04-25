//
//  UserTableModel.h
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTableModel : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *content;

@property (assign, nonatomic) BOOL isClick;

@property (strong ,nonatomic) UIImage *image;


+(UserTableModel *)buildModel : (UIImage *)image title: (NSString *)title content : (NSString *)content isClick : (BOOL)isClick;
@end
