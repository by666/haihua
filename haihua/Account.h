//
//  Accout.h
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACCOUNT_INFO_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account_info.data"]

#define TOKEN @"hh_token"
#define UID @"hh_uid"
#define TEL @"hh_tel"

@interface Account : NSObject

@property (copy , nonatomic) NSString *uid;

@property (copy , nonatomic) NSString *token;

@property (copy , nonatomic) NSString *tel;


SINGLETON_DECLARATION(Account);

- (void)savaAccount:(Account *)account;

- (void)saveTel:(NSString *)tel;

- (BOOL)isLogin;

- (NSString *)getUid;

- (NSString *)getToken;

- (NSString *)getTel;

@end
