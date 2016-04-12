//
//  UIPlaceholderTextView.h
//  haihua
//
//  Created by by.huang on 16/3/23.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceholderTextView : UITextView
@property(nonatomic, strong) NSString *placeholder;     //占位符

-(void)addObserver;//添加通知
-(void)removeobserver;//移除通知

@end