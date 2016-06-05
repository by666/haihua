//
//  AppUtil.h
//  haihua
//
//  Created by by.huang on 16/3/22.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (BOOL)checkTel:(NSString *)str;

+ (BOOL)checkUserIdCard: (NSString *) idCard;

+(NSString*)imageMD5:(UIImage*)image;

+(NSString*)fileMD5:(NSString*)path;

+(UIImage*)transformImage : (UIImage *)image
                    width  : (CGFloat)width
                    height : (CGFloat)height;

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (CGFloat)pointValue:(CGFloat)pixel;

@end
