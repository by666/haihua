//
//  UserInfoView.h
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

+(void)show : (BaseViewController *)controller;

@end
