//
//  AppDelegate.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ImproveInfoViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MiPushSDK.h"
#import "Account.h"
#import "ImproveInfoViewController.h"
#import "LoginViewController.h"
#import "CheckUpdateUtil.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSString *updateUrl;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = BACKGROUND_COLOR;
    
    //注册短信验证码
    [SMSSDK registerApp:@"1aa17da0ab818" withSecret:@"8074bcf8ed9a0fe39d048955e326b601"];
    
    // 同时启用APNs跟应用内长连接
    [MiPushSDK registerMiPush:self type:0 connect:YES];

//    [MiPushSDK unregisterMiPush];

    
    [NSThread sleepForTimeInterval:3.0];

    [self launchViewController];
//    [self requestUpdate];

    [[CheckUpdateUtil sharedCheckUpdateUtil] check];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


-(void)launchViewController
{
    UINavigationController *controller;
    Account *account = [Account sharedAccount];
    if(![account isLogin])
    {
        LoginViewController *loginController = [[LoginViewController alloc]init];
        loginController.hideClose = YES;
        controller= [[UINavigationController alloc]initWithRootViewController:loginController];
    }
    else
    {
    
        HomeViewController *homeViewController= [[HomeViewController alloc]init];
        controller= [[UINavigationController alloc]initWithRootViewController:homeViewController];
    }
    _window.rootViewController = controller;
    [_window makeKeyAndVisible];
}

#pragma mark MiPushSDKDelegate

//ios7
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger villageId = [userDefaults integerForKey:VillageID];
    // 设置别名
    [MiPushSDK setAlias:[[Account sharedAccount] getUid]];
    // 订阅内容
    [MiPushSDK subscribe:[NSString stringWithFormat:@"%d",(int)villageId]];
//    // 设置帐号
//    [MiPushSDK setAccount:@"account"];
    
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败
    // 自行处理
}

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
}

-(void)miPushReceiveNotification:(NSDictionary *)data
{
    
}


-(void)requestUpdate
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pt"] = @"0";
    params[@"ver"] = appCurVersionNum;
    
    [manager GET:Request_Update parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == UPDATE)
         {
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"是否更新到最新版本？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             updateUrl = model.data;
             [alertView show];
             
         }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(!IS_NS_STRING_EMPTY(updateUrl))
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
        }

    }
}

@end
