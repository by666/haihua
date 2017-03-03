//
//  TimeUtil.m
//  haihua
//
//  Created by by.huang on 2017/3/3.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil

+ (NSString *) formatTime:(NSDate *)date
{
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSDate * nowDate = [NSDate date];
        
        NSTimeInterval time = [nowDate timeIntervalSinceDate:date];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  // 1分钟以内的
            
            dateStr = @"刚刚";
        }else if(time<=60*60){  //  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   // 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:date];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
                NSLog(@"%@", dateStr);
            }else{
                //  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:date];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:date];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:date];
            }
            
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

@end
