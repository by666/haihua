//
//  UIPlaceholderTextView.h
//  haihua
//
//  Created by by.huang on 16/3/23.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIPlaceholderTextViewDelegate <NSObject>

@optional -(void)OnClickConfirm;

@end

@interface UIPlaceholderTextView : UITextView<UITextViewDelegate>
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic,strong) id<UIPlaceholderTextViewDelegate> holderDelegate;

-(void)addObserver;//添加通知
-(void)removeobserver;//移除通知

@end
