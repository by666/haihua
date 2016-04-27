//
//  CommentModel.h
//  haihua
//
//  Created by by.huang on 16/3/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject


@property (assign , nonatomic) long gcid;

@property (assign , nonatomic) long uid;

@property (assign , nonatomic) long mid;

@property (assign , nonatomic) long ts;

@property (copy , nonatomic) NSString *type;

@property (copy , nonatomic) NSString *content;

@property (copy , nonatomic) NSString *sex;

@property (copy , nonatomic) NSString *name;

@property (assign, nonatomic)int avatar;

@end
