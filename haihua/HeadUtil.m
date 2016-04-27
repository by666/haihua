//
//  HeadUtil.m
//  haihua
//
//  Created by by.huang on 16/4/28.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "HeadUtil.h"

@implementation HeadUtil

+(UIImage *)getHeadImage : (NSString *)gender
                position : (NSInteger)position
{
    UIImage *image = nil;
    if([gender isEqualToString:@"man"])
    {
        switch (position) {
            case 0:
                image = [UIImage imageNamed:@"ic_boy_a"];
                break;
            case 1:
                image = [UIImage imageNamed:@"ic_boy_b"];
                break;
            case 2:
                image = [UIImage imageNamed:@"ic_boy_c"];
                break;
            case 3:
                image = [UIImage imageNamed:@"ic_boy_d"];
                break;
            case 4:
                image = [UIImage imageNamed:@"ic_boy_e"];
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (position) {
            case 0:
                image = [UIImage imageNamed:@"ic_girl_a"];
                break;
            case 1:
                image = [UIImage imageNamed:@"ic_girl_b"];
                break;
            case 2:
                image = [UIImage imageNamed:@"ic_girl_c"];
                break;
            case 3:
                image = [UIImage imageNamed:@"ic_girl_d"];
                break;
            case 4:
                image = [UIImage imageNamed:@"ic_girl_e"];
                break;
                
            default:
                break;
        }
    }
    return image;
}

@end
