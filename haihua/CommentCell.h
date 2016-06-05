//
//  CommentCell.h
//  haihua
//
//  Created by by.huang on 16/3/26.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell

-(UILabel *)getLabel;

-(void)setData : (CommentModel *)model;

+(NSString *)identify;


@end
