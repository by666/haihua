//
//  FileDataParams.h
//  haihua
//
//  Created by by.huang on 16/3/30.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDataParams : NSObject


// 文件二进制数据
@property(nonatomic, strong) NSData *content;

// 电话
@property(nonatomic, copy) NSString *tel;

// token
@property(nonatomic, copy) NSString *token;

// 标题
@property(nonatomic, copy) NSString *title;

//md5s
@property(nonatomic, copy) NSString *md5s;

@end
