//
//  AppDelegate.m
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "VillageListViewController.h"
#import "ImproveInfoViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MiPushSDK.h"
#import "Account.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = BACKGROUND_COLOR;
    
    //注册短信验证码
    [SMSSDK registerApp:@"1134ecdcdc9a0" withSecret:@"9270e02945484275b3946ced8ae91392"];
    
    // 同时启用APNs跟应用内长连接
    [MiPushSDK registerMiPush:self type:0 connect:YES];
//    [MiPushSDK unregisterMiPush];

    
    [self launchViewController];
    
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

/*
-(void)firstScreen
{
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:self.window.frame];
    niceView.image = [UIImage imageNamed:@"splash"];
    [self.window addSubview:niceView];
    [self.window bringSubviewToFront:niceView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    niceView.alpha = 0.0;
    niceView.frame = CGRectMake(-SCREEN_WIDTH * 0.25, -SCREEN_HEIGHT * 0.25, SCREEN_WIDTH *1.5, SCREEN_HEIGHT * 1.5);
    [UIView commitAnimations];

//    UIView *firstScreenView = [[UIView alloc]init];
//    firstScreenView.frame = self.window.bounds;
//    firstScreenView.backgroundColor = [UIColor whiteColor];
//    [self.window addSubview:firstScreenView];
//    
//    NSArray *array = @[@"上",@"善",@"若",@"水",@"厚",@"德",@"载",@"物"];
//    NSMutableArray *labels = [[NSMutableArray alloc]init];
//    for(int i = 0; i<[array count] ; i++)
//    {
//        UILabel *label = [[UILabel alloc]init];
//        label.font =  [UIFont systemFontOfSize:30];
//        label.text = [array objectAtIndex:i];
//        if(i < [array count]/2)
//        {
//            label.frame = CGRectMake(SCREEN_WIDTH *2/3, SCREEN_HEIGHT /6 + 60 * i, label.contentSize.width, label.contentSize.height);
//        }
//  
//        else
//        {
//            label.frame = CGRectMake(SCREEN_WIDTH *1/3, SCREEN_HEIGHT /6 + 30 + 60 * (i - 4), label.contentSize.width, label.contentSize.height);
//        }
//        [firstScreenView addSubview:label];
//        [labels addObject:label];
//    }
    
}
*/
-(void)launchViewController
{
    UINavigationController *controller;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger villageId = [userDefaults integerForKey:VillageID];
    NSString *name = [userDefaults valueForKey:VillageName];
    Account *account = [Account sharedAccount];
    if(![account isLogin])
    {
        VillageListViewController *villageListController =[[VillageListViewController alloc]init];
        controller= [[UINavigationController alloc]initWithRootViewController:villageListController];
    }
    else
    {
        
        MainViewController *mainViewController= [[MainViewController alloc]init];
        mainViewController.villageId = villageId;
        mainViewController.name = name;
        controller= [[UINavigationController alloc]initWithRootViewController:mainViewController];
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

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
}

#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger villageId = [userDefaults integerForKey:VillageID];
    // 设置别名
    [MiPushSDK setAlias:[[Account sharedAccount] getUid]];
    // 订阅内容
    [MiPushSDK subscribe:[NSString stringWithFormat:@"%d",(int)villageId]];
    // 设置帐号
    [MiPushSDK setAccount:@"account"];
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

@end
