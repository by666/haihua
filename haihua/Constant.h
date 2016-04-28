//
//  Constant.h
//  haihua
//
//  Created by by.huang on 16/3/13.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 网络请求相关
#define Root_Url @"http://120.25.196.33/est/"

//请求小区列表
#define Request_VillageList [Root_Url stringByAppendingString: @"api/community/list"]

//请求验证码
#define Request_VerifyCode [Root_Url stringByAppendingString: @"api/user/login/verify"]

//请求登录
#define Request_Login [Root_Url stringByAppendingString: @"api/login/request"]

//提交用户信息
#define Request_Commit [Root_Url stringByAppendingString: @"api/user/update"]

//请求用户信息
#define Request_GetUserInfo [Root_Url stringByAppendingString: @"api/user/get"]



//请求政务信息列表
#define Request_InfoList [Root_Url stringByAppendingString: @"api/msg/gov/list"]

//请求我参与的政务信息列表
#define Request_MyInfoList [Root_Url stringByAppendingString: @"api/msg/gov/list/my"]

//请求评论列表
#define Request_CommentList [Root_Url stringByAppendingString:@"api/msg/gov/comment/list"]

//提交评论
#define Request_Comment [Root_Url stringByAppendingString:@"api/msg/gov/comment/add"]

//请求投票结果
#define Request_VoteResult [Root_Url stringByAppendingString:@"api/msg/gov/vote/list"]

//提交投票
#define Request_Vote [Root_Url stringByAppendingString:@"api/msg/gov/vote/add"]

//提交意见反馈
#define Request_FeedBack [Root_Url stringByAppendingString: @"api/feedback/add"]

//请求意见反馈列表
#define Request_FeedBack_List [Root_Url stringByAppendingString: @"api/feedback/list"]

//请求我的意见反馈列表
#define Request_MyFeedBack_List [Root_Url stringByAppendingString: @"api/feedback/list/my"]



#define Info_Net_Error @"网络异常，点击刷新"



#pragma mark 小区信息存储
#define VillageID @"villageId"
#define VillageName @"villageName"