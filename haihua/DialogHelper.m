//
//  DialogHelper.m
//  Radar
//
//  Created by mark.zhang on 6/30/15.
//  Copyright (c) 2015 com.brotherhood. All rights reserved.
//

#import "DialogHelper.h"
#import "IDSAlertSheet.h"

@implementation DialogHelper

+ (IDSAlertSheet *)showDialog:(NSString *)title withDelegate:(id<IDSAlertSheetDelegate>)delegate
{
    NSArray *buttons = [NSArray arrayWithObjects:@"确定", @"取消", nil];
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:title buttonTitles:buttons];
    if (delegate) {
        dialog.alertDelegate = delegate;
    }
    
    [dialog setSheetButtonTitleColor:1 withColor:[UIColor redColor]];
    [dialog showDimMask];
    dialog.outerSideCanCancel = NO;
    [dialog show];
    
    return dialog;
}

+ (IDSAlertSheet *)showDialog:(NSString *)title withButtonsTitle:(NSArray *)array withDelegate:(id<IDSAlertSheetDelegate>)delegate
{
    NSArray *buttons = [NSArray arrayWithArray:array];
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:title buttonTitles:buttons];
    if (delegate) {
        dialog.alertDelegate = delegate;
    }
    
    [dialog setSheetButtonTitleColor:1 withColor:[UIColor redColor]];
    [dialog showDimMask];
    dialog.outerSideCanCancel = NO;
    
    [dialog show];
    
    return dialog;
}

+ (void)showTips:(NSString *)tips
{
    UIImage *image = [UIImage imageNamed:@"ic_error_cross_normal"];
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:tips titleIcon:image];
    [dialog showFailure];
}

+ (void)showFailureAlertSheet:(NSString *)title
{
    if ([title isEqualToString:@"成功"]) {
        return;
    }
    UIImage *image = [UIImage imageNamed:@"ic_error_cross_normal"];
    IDSAlertSheet *sheet = [[IDSAlertSheet alloc] initWithTitle: title titleIcon:image];
    [sheet showFailure];
}

+ (void)showSuccessTips:(NSString *)tips
{
    UIImage *image = [UIImage imageNamed:@"ic_event_correct_normal"];
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:tips titleIcon:image];
    [dialog showSuccess];
}

+ (void)showSuccessTipsNoIcon:(NSString *)tips
{
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:tips titleIcon:nil];
    [dialog showSuccess];
}

+ (void)showWarnTips:(NSString *)tips
{
    IDSAlertSheet *dialog = [[IDSAlertSheet alloc] initWithTitle:tips];
    [dialog showWithUIColor:WarnColor];
}

@end
