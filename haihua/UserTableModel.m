//
//  UserTableModel.m
//  haihua
//
//  Created by by.huang on 16/3/29.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "UserTableModel.h"

@implementation UserTableModel

+(UserTableModel *)buildModel : (NSString *)title content : (NSString *)content isClick : (BOOL)isClick
{
    UserTableModel *tableModel = [[UserTableModel alloc]init];
    tableModel.title = title;
    tableModel.content = content;
    tableModel.isClick = isClick;
    return tableModel;
}
@end
