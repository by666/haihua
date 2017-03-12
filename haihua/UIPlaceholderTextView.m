//
//  UIPlaceholderTextView.m
//  haihua
//
//  Created by by.huang on 16/3/23.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UIPlaceholderTextView.h"

@interface UIPlaceholderTextView ()

@property (nonatomic, strong) UIColor* textColor;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation UIPlaceholderTextView
@synthesize placeholder;
@synthesize textColor;

//当用nib创建时会调用此方法
- (instancetype)init {
    if(self == [super init])
    {
        self.delegate = self;
        self.returnKeyType = UIReturnKeyDone;
        [self addObserver];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if(_holderDelegate != nil)
        {
            if([(NSObject *)_holderDelegate respondsToSelector:@selector(OnClickConfirm)] == YES )
            {
                [_holderDelegate OnClickConfirm];
            }
        }
        return NO;
    }
    
    return YES;
}


-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}
-(void)removeobserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Setter/Getters
- (void) setPlaceholder:(NSString *)aPlaceholder {
    placeholder = aPlaceholder;
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:placeholder]) return @"";
    return text;
}

- (void) beginEditing:(NSNotification*) notification {
    if ([super.text isEqualToString:placeholder]) {
        super.text = nil;
        //字体颜色
        [super setTextColor:textColor];
    }
    
}

- (void) endEditing:(NSNotification*) notification {
    if ([super.text isEqualToString:@""] || self.text == nil) {
        super.text = placeholder;
        //注释颜色
        [super setTextColor:[UIColor lightGrayColor]];
    }
}

@end
