//
//  MainViewController.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface MsgListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

+(void)show : (UIViewController *)controller
       title: (NSString *)title
        type: (NSString *)type
       mine : (BOOL) isMine
     isVote : (BOOL) isVote;

+(void)show : (UIViewController *)controller
       title: (NSString *)title
        type: (NSString *)type
       mine : (BOOL) isMine
     isVote : (BOOL) isVote
       temp : (NSString *)temp;

@end
