//
//  MessageModel.h
//  haihua
//
//  Created by by.huang on 16/3/21.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"
@interface MsgModel : NSObject

//mid
@property (assign, nonatomic) long mid;

//uid
@property (assign, nonatomic) int uid;

//cid
@property (assign, nonatomic) int cid;

//标题
@property (copy, nonatomic) NSString *title;

//发布时间
@property (assign, nonatomic) long publishTs;

//信息类型
@property (copy ,nonatomic)NSString *type;

//创建时间
@property (assign, nonatomic) long createTs;

//statuEdit
@property (assign, nonatomic) BOOL statusEdit;

//截至时间
@property (assign, nonatomic) long endTs;

//总评论数
@property (assign, nonatomic) int totalComment;

//typeVote
@property (assign, nonatomic) BOOL typeVote;

@property (assign, nonatomic) Boolean commented;

//图文内容
@property (strong, nonatomic) NSMutableArray *picNotes;

@property (assign, nonatomic) BOOL hasVote;

@property (assign, nonatomic) Boolean isVote;

//投票结果
@property (strong, nonatomic) NSMutableArray *options;


@end
