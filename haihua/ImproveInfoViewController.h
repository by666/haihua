//
//  ImproveInfoViewController.h
//  haihua
//
//  Created by by.huang on 16/3/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

@protocol ImproveInfoDelegate

@optional -(void)OnSelectVillage : (int)villageId name : (NSString *)villageName;

@end

@interface ImproveInfoViewController : BaseViewController<ImproveInfoDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (copy, nonatomic) NSString *tel;

+(void)show : (BaseViewController *)controller tel : (NSString *)tel;

@end
