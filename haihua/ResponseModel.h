//
//  ResponseModel.h
//  Radar
//
//  Created by mark.zhang on 6/29/15.
//  Copyright (c) 2015 com.brotherhood. All rights reserved.
//

#import <MJExtension.h>

#define SUCCESS_CODE 1
//参数异常
#define ERROR_PARAM 2
//用户不存在
#define ERROR_NO_USER 3
//需要验证用户信息
#define SUCCESS_NEED_VERIFY 4
//登陆验证码有误
#define ERROR_VERIFY_CODE 5
//服务端异常
#define ERROR_SERVICE 6
//token异常
#define ERROR_TOKEN 7
//用户不在小区内
#define ERROR_USER_NOT_IN_VILLAGE 8
//用户已提交
#define SUCCESS_USER_COMMITED 9
//用户尚未验证通过
#define SUCCESS_VERIFY_FAIL 10
//信息不存在
#define ERROR_INFO 11
//小区不存在
#define ERROR_VILLAGE_NOT_EXIT 12

@interface ResponseModel : NSObject

@property (assign, nonatomic) int code;

@property (strong, nonatomic) id data;

@property (copy, nonatomic) NSString *msg;

@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *status;

@property (assign, nonatomic) long commentedVoId;

//反馈数
@property (assign, nonatomic)int total_feedback;

//评论数
@property (assign, nonatomic)int total_msg;

//投票数
@property (assign, nonatomic)int total_vote;

@end
