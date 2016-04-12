//
//  TabButton.h
//  haihua
//
//  Created by by.huang on 16/3/22.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Normal = 0,
    Press = 1
} TabButtonType;

@interface TabButton : UIButton


-(instancetype)initWithImageAndText : (NSString *)text normal:(UIImage *)normalImage
                 pressImage : (UIImage *)pressImage;

-(void)changeState:(TabButtonType) type;

@end
