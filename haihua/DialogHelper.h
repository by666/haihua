//
//  DialogHelper.h
//  Radar
//
//  Created by mark.zhang on 6/30/15.
//  Copyright (c) 2015 com.brotherhood. All rights reserved.
//

#import "IDSAlertSheet.h"

@interface DialogHelper : NSObject

+ (IDSAlertSheet *)showDialog:(NSString *)title withDelegate:(id<IDSAlertSheetDelegate>)delegate;

//封装 Alertsheet with buttons array
+ (IDSAlertSheet *)showDialog:(NSString *)title withButtonsTitle:(NSArray *)array withDelegate:(id<IDSAlertSheetDelegate>)delegate;

+ (void)showTips:(NSString *)tips;

//封装 Failure Alertsheet
+ (void)showFailureAlertSheet:(NSString *)title;

+ (void)showSuccessTips:(NSString *)tips;

+ (void)showSuccessTipsNoIcon:(NSString *)tips;

+ (void)showWarnTips:(NSString *)tips;

@end
