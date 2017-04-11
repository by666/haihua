//
//  VoteItemCell.m
//  haihua
//
//  Created by by.huang on 16/3/31.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VoteItemCell.h"
#define ITEM_HEIGHT 50

@interface VoteItemCell()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIView *progressView;

@property (strong , nonatomic) UILabel *optionLabel;

@property (strong, nonatomic) UILabel *percentLabel;

@end

@implementation VoteItemCell
{
    int ProgressWidth;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.backgroundColor = [UIColor clearColor];

    ProgressWidth = SCREEN_WIDTH - 40;
    
    _bgView = [[UIView alloc]init];
    _bgView.frame = CGRectMake(10, 10, ProgressWidth, ITEM_HEIGHT-10);
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor  = LINE_COLOR;
    _bgView.layer.cornerRadius = (ITEM_HEIGHT - 10 )/2;
//    _bgView.layer.borderColor = [Bold_COLOR CGColor];
//    _bgView.layer.borderWidth = 1;
    _bgView.userInteractionEnabled = NO;
    [self.contentView addSubview:_bgView];
    
    _progressView = [[UIView alloc]init];
    _progressView.layer.masksToBounds = YES;
    _progressView.userInteractionEnabled = NO;
    _progressView.backgroundColor  = LINE_COLOR;
    _progressView.frame = CGRectMake(10, 10, 0, ITEM_HEIGHT-10);
    [self.contentView addSubview:_progressView];
    
    _optionLabel = [[UILabel alloc]init];
    _optionLabel.textColor = [UIColor blackColor];
    _optionLabel.font = [UIFont systemFontOfSize:16.0f];
    _optionLabel.backgroundColor = [UIColor clearColor];
    _optionLabel.frame = CGRectMake(10, 10, ProgressWidth, ITEM_HEIGHT-10);
    _optionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_optionLabel];
    
    _percentLabel = [[UILabel alloc]init];
    _percentLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _percentLabel.font = [UIFont systemFontOfSize:14.0f];
    _percentLabel.hidden = YES;
    [self.contentView addSubview:_percentLabel];
}


-(void)setData : (VoteModel *)model
{
    _optionLabel.text = model.option;

    float percent = 0;
    if(model.allTotal > 0)
    {
        percent = (float)model.total / (float)model.allTotal;
    }
    _percentLabel.text = [[NSString stringWithFormat:@"%.1f",percent * 100] stringByAppendingString:@"%"];
    _percentLabel.frame = CGRectMake(SCREEN_WIDTH - 50 - _percentLabel.contentSize.width, 10, _percentLabel.contentSize.width, ITEM_HEIGHT-10);

    if(model.hasVote)
    {
        _percentLabel.hidden = NO;
        if(model.commentedVoId == model.voId)
        {
            _progressView.backgroundColor  = [ColorUtil colorWithHexString:@"#ffcdb1"];
        }
        else
        {
            _progressView.backgroundColor  = [ColorUtil colorWithHexString:@"#000000" alpha:0.2f];
        }
        
        [UIView animateWithDuration:2.0f animations:^{
            _progressView.frame = CGRectMake(10, 10,  ProgressWidth * percent, ITEM_HEIGHT-10);
        } completion:^(BOOL finished) {
            
        }];
        
        if(ProgressWidth * percent > ProgressWidth - (ITEM_HEIGHT - 10 )/2)
        {
            _progressView.layer.cornerRadius = (ITEM_HEIGHT - 10 )/2;
        }
        else
        {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:_progressView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: (CGSize){(ITEM_HEIGHT - 10 )/2, (ITEM_HEIGHT - 10 )/2}].CGPath;
            _progressView.layer.mask = maskLayer;
        }

    }
    else
    {
        _percentLabel.hidden = YES;
        if(model.isSeleted)
        {
            _bgView.backgroundColor  = [UIColor orangeColor];
        }
        else
        {
            _bgView.backgroundColor  = LINE_COLOR;
        }
    }


}


+(NSString *)identify
{
    return @"VoteItemCell";
}

@end
