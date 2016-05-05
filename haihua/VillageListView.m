//
//  VillageListView.m
//  haihua
//
//  Created by by.huang on 16/4/25.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "VillageListView.h"
#import "VillageCell.h"

#define VV_WIDTH  SCREEN_WIDTH - 30
#define VV_HEIGHT 350


@interface VillageListView()

@property (copy , nonatomic) NSMutableArray *datas;

@property (strong , nonatomic) UITableView *tableView;

@property (strong , nonatomic) UILabel *titleLabel;

@property (strong , nonatomic) UIButton *cancelBtn;

@end

@implementation VillageListView


-(instancetype)init
{
    if(self == [super init])
    {
        _datas = [[NSMutableArray alloc]init];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.2f];
        [self requestList];
    }
    return self;
}

-(void)initView
{
    
    UIView *rootView = [[UIView alloc]init];
    rootView.backgroundColor = [UIColor whiteColor];
    rootView.layer.masksToBounds = YES;
    rootView.layer.cornerRadius = 4;
    rootView.frame = CGRectMake(15, (SCREEN_HEIGHT - VV_HEIGHT)/2, VV_WIDTH, VV_HEIGHT);
    
    [self addSubview:rootView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请选择小区";
    label.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.frame = CGRectMake(15, 15, label.contentSize.width, label.contentSize.height);
    [rootView addSubview:label];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.frame = CGRectMake(15, 50, VV_WIDTH-30, VV_HEIGHT -100);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rootView addSubview:_tableView];
    
    
    _cancelBtn = [[UIButton alloc]init];
    [_cancelBtn setBackgroundColor:[UIColor clearColor]];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_cancelBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.frame = CGRectMake(VV_WIDTH - 15 - 30., VV_HEIGHT - 40, 30, 30);
    [rootView addSubview:_cancelBtn];
    
    
}

#pragma mark 列表处理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        return [_datas count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VillageCell *cell = [[VillageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[VillageCell identify]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_datas))
    {
        [cell setData:[_datas objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VillageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelect:YES];
  
    if(_model.admin == 1)
    {
        [self requestSelectVillage:indexPath.row];
    }
    else
    {
        if(self.delegate)
        {
            [self.delegate OnSelectVillage:[_datas objectAtIndex:indexPath.row]];
        }
    }
    [self removeFromSuperview];
    
}


/**
 *  请求小区列表
 */
-(void)requestList
{
    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(_model.admin == 1)
    {
        params[@"uid"] = [NSString stringWithFormat:@"%d",_model.uid];
    }
    [_datas removeAllObjects];
    [manager GET:Request_VillageList parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             id data = model.data;
             _datas = [VillageModel mj_objectArrayWithKeyValuesArray:data];
             [self initView];
         }
         hua.hidden = YES;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         hua.hidden = YES;
     }];
    
}


/**
 *  请求切换小区
 */
-(void)requestSelectVillage : (NSInteger)position
{
    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    VillageModel *model =  [_datas objectAtIndex:position];
    params[@"uid"] = [NSString stringWithFormat:@"%d",_model.uid];
    params[@"cid"] = [NSString stringWithFormat:@"%d",model.villageId];
    [manager GET:Request_Select_Village parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             if(self.delegate)
             {
                 [self.delegate OnSelectVillage:[_datas objectAtIndex:position]];
             }
         }
         hua.hidden = YES;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         hua.hidden = YES;
     }];
    
}

-(void)OnClick : (id)sender
{
    if(sender == _cancelBtn)
    {
        [self removeFromSuperview];
    }
}


#pragma mark 触摸起他区域
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
