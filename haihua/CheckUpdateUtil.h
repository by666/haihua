//
//  CheckUpdateUtil.h
//  haihua
//
//  Created by by.huang on 16/5/11.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUpdateUtil : NSObject<UIAlertViewDelegate>

SINGLETON_DECLARATION(CheckUpdateUtil);

#pragma mark 检查更新
-(void)check;

@end
