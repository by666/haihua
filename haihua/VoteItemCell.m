//
//  VoteItemCell.m
//  haihua
//
//  Created by by.huang on 16/3/31.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VoteItemCell.h"

@interface VoteItemCell()

@property (strong , nonatomic) UILabel *voteTitleLabel;

@property (strong, nonatomic) UIView *bgProgress;

@property (strong, nonatomic) UIView *mainProgress;

@property (strong, nonatomic) UIButton *selectButton;

@property (strong, nonatomic) UILabel *countLabel;

@end

@implementation VoteItemCell

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
    _voteTitleLabel = [[UILabel alloc]init];
    _voteTitleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _voteTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_voteTitleLabel];
    
    
    _bgProgress = [[UIView alloc]init];
    _bgProgress.layer.cornerRadius = 6;
    _bgProgress.layer.masksToBounds = YES;
    _bgProgress.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bgProgress];
    
    
    _mainProgress = [[UIView alloc]init];
    _mainProgress.layer.cornerRadius = 6;
    _mainProgress.layer.masksToBounds = YES;
    _mainProgress.backgroundColor = MAIN_COLOR;
    [self.contentView addSubview:_mainProgress];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];

    _countLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_countLabel];
    
    _selectButton = [[UIButton alloc]init];
    _selectButton.userInteractionEnabled = NO;
    [_selectButton setImage:[UIImage imageNamed:@"ic_select_normal"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"ic_select_press"] forState:UIControlStateSelected];
    _selectButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_selectButton];
    
}

-(void)setData : (VoteModel *)model
{
    if(model.hasVote)
    {
        _bgProgress.hidden = NO;
        _mainProgress.hidden = NO;
        _selectButton.hidden = YES;
        
        _voteTitleLabel.text = model.option;
        _voteTitleLabel.frame = CGRectMake(15, 5, _voteTitleLabel.contentSize.width, _voteTitleLabel.contentSize.height);
        
        
        double total = SCREEN_WIDTH -30;
        _bgProgress.frame = CGRectMake(15, 10  + _voteTitleLabel.contentSize.height , total, 12);

        double actualWidth = 0;
        if(model.allTotal == 0)
        {
            actualWidth = 0;
        }
        else
        {
            actualWidth =((double)model.total /(double) model.allTotal ) * total;
        }
        _mainProgress.frame = CGRectMake(15, 10  + _voteTitleLabel.contentSize.height,actualWidth , 12);
        
        int percent = 0;
        if(model.allTotal == 0)
        {
            percent = 0;
        }
        else
        {
            percent = ((double)model.total / (double)model.allTotal ) * 100;
        }
        _countLabel.text = [NSString stringWithFormat:@"%d票  %d%@",model.total,percent,@"%"];
        _countLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - _countLabel.contentSize.width, 5, _countLabel.contentSize.width, _countLabel.contentSize.height);

    }
    else
    {
        _bgProgress.hidden = YES;
        _mainProgress.hidden = YES;
        _selectButton.hidden = NO;
        
        _voteTitleLabel.text = model.option;
        _voteTitleLabel.frame = CGRectMake(15, (self.contentView.height - _voteTitleLabel.contentSize.height ) / 2, _voteTitleLabel.contentSize.width, _voteTitleLabel.contentSize.height);
        
        _selectButton.frame = CGRectMake(SCREEN_WIDTH - 15 - 24 , (self.contentView.height - 24 ) / 2, 24, 24);
        if(model.isSeleted)
        {
            [_selectButton setSelected:YES];
        }
        else
        {
            [_selectButton setSelected:NO];
        }
    }
    



}


+(NSString *)identify
{
    return @"VoteItemCell";
}

@end
