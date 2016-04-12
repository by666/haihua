//
//  MessageModel.h
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

//id
@property (assign, nonatomic) long mid;
//信息类型
@property (copy ,nonatomic)NSString *type;

//标题
@property (copy, nonatomic) NSString *title;

//内容
@property (copy, nonatomic) NSString *content;

//发布时间
@property (assign, nonatomic) long publishTs;

//截至时间
@property (assign, nonatomic) long endTs;

//创建时间
@property (assign, nonatomic) long createTs;

//评论总数
@property (assign, nonatomic) int totalComment;

//备注, 主要用于投票信息里面的小标题
@property (copy ,nonatomic) NSString *note;

//indexID
@property (assign, nonatomic) int index;

@end
