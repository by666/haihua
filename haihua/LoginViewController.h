//
//  LoginViewController.h
//  haihua
//
//  Created by by.huang on 16/3/23.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<ByNavigationBarDelegate>

@property (assign, nonatomic)BOOL hideClose;

+(void)show : (BaseViewController *)controller;

//是否隐藏关闭按钮
+(void)show : (BaseViewController *)controller close : (BOOL)hideClose;

@end
