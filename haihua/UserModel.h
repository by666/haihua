//
//  UserModel.h
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

//用户id
@property (assign, nonatomic) int uid;

//用户姓名
@property (copy, nonatomic) NSString *name;

//性别
@property (copy, nonatomic) NSString *sex;

//身份证号
@property (copy, nonatomic) NSString *idcard;

//手机号
@property (copy, nonatomic) NSString *tel;

//所在小区id
@property (assign, nonatomic) int cid;

//小区名称
@property (copy, nonatomic) NSString *communityName;

//所在小区门牌号
@property (copy,nonatomic) NSString *gatehouse;

//验证状态
@property (copy, nonatomic) NSString *verified;

//头像位置
@property (assign, nonatomic)int avatar;

//反馈数
@property (assign, nonatomic)int total_feedback;

//评论数
@property (assign, nonatomic)int total_msg;

//投票数
@property (assign, nonatomic)int total_vote;

//是否是管理员
@property (assign, nonatomic)int admin;



@end
