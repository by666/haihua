//
//  UserInfoView.h
//  haihua
//
//  Created by by.huang on 16/3/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserInfoView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BaseViewController *controller;

-(instancetype)initWithInfoView : (BaseViewController *)controller;
@end
