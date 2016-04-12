//
//  Accout.m
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "Account.h"

@implementation Account


SINGLETON_IMPLEMENTION(Account);


- (void)savaAccount:(Account *)account
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:account.uid forKey:UID];
    [userDefaults setValue:account.token forKey:TOKEN];

}

- (void)saveTel:(NSString *)tel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:tel forKey:TEL];
    
}

- (BOOL)isLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:UID];
    NSString *token = [userDefaults objectForKey:TOKEN];
    return (!IS_NS_STRING_EMPTY(uid) && !IS_NS_STRING_EMPTY(token));
}

- (NSString *)getUid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:UID];
    return uid;
}

-(NSString *)getToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:TOKEN];
    return token;
}

-(NSString *)getTel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tel = [userDefaults objectForKey:TEL];
    return tel;
}

@end
