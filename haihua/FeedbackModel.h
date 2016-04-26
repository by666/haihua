//
//  FeedbackModel.h
//  haihua
//
//  Created by by.huang on 16/4/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject

//反馈id
@property (assign , nonatomic) int fid;

//小区id
@property (assign , nonatomic) int cid;

//用户id
@property (assign , nonatomic) int uid;

//发表时间
@property (assign , nonatomic) long ts;

//标题
@property (copy , nonatomic) NSString *title;

//内容
@property (copy , nonatomic) NSString *content;

//状态
@property (copy , nonatomic) NSString *status;

//用户名
@property (copy , nonatomic) NSString *name;

//性别
@property (copy , nonatomic) NSString *sex;

//图片集对象
@property (strong , nonatomic) NSDictionary *pics;

//图片集合
@property (strong, nonatomic) NSMutableArray *pictures;


//{
//    "index": 2,
//    "data": [
//             {
//                 "fid": 21,
//                 "cid": 1,
//                 "uid": 1,
//                 "ts": 1460740040,
//                 "title": "点击点击",
//                 "content": "手机计算机",
//                 "pics": {
//                     "e796e24188f2acf075c0464a398fbe6a": "http://120.25.196.33/pic/e796e24188f2acf075c0464a398fbe6a",
//                     "53aaa519a48bc608ffb6bf36f4b68262": "http://120.25.196.33/pic/53aaa519a48bc608ffb6bf36f4b68262"
//                 },
//                 "status": "untreated",
//                 "name": "胡镇杰",
//                 "sex": "man"
//             },
//             {
//                 "fid": 20,
//                 "cid": 1,
//                 "uid": 1,
//                 "ts": 1460739802,
//                 "title": "相同图片",
//                 "content": "相同",
//                 "pics": {
//                     "cee10b82190b41aa4af4212f8eb0869b": "http://120.25.196.33/pic/cee10b82190b41aa4af4212f8eb0869b"
//                 },
//                 "status": "untreated",
//                 "name": "胡镇杰",
//                 "sex": "man"
//             }
//             ],
//    "code": 1,
//    "msg": "OK"
//}

@end
