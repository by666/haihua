//
//  ByNavigationBar.h
//  haihua
//
//  Created by by.huang on 16/3/8.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ByNavigationBarDelegate

@optional -(void)OnLeftClickCallback;

//@optional -(void)OnRightClickCallback;

@optional -(void)OnTitleClick;

@end

@interface ByNavigationBar : UIView

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UIButton *leftBtn;

//@property (strong,nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) UIButton *titleClickBtn;

@property (strong,nonatomic) id delegate;

-(void)setTitle : (NSString *)title;

-(void)setTitleClick : (BOOL)isClick;


@end
