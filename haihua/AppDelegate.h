//
//  AppDelegate.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MiPushSDKDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

