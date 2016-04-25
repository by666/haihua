//
//  ImproveInfoViewController.h
//  haihua
//
//  Created by by.huang on 16/3/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "VillageListView.h"

@interface ImproveInfoViewController : BaseViewController<UITextViewDelegate,UIAlertViewDelegate,ByNavigationBarDelegate,VillageListViewDelegate>

@property (copy, nonatomic) NSString *tel;

+(void)show : (BaseViewController *)controller tel : (NSString *)tel;

@end
