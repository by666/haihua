//
//  ImproveInfoViewController.m
//  haihua
//
//  Created by by.huang on 16/3/27.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "ImproveInfoViewController.h"
#import "ResponseModel.h"
#import "UIPlaceholderTextView.h"
#import "VillageModel.h"
#import "AppUtil.h"
#import "DialogHelper.h"
#import "Account.h"
#import "HomeViewController.h"
#import "VillageListView.h"

@interface ImproveInfoViewController ()

@property (strong, nonatomic) UIPlaceholderTextView *nameTextView;

@property (strong, nonatomic) UIPlaceholderTextView *cardIDTextView;

@property (strong, nonatomic) UIPlaceholderTextView *gateHouseTextView;

@property (strong, nonatomic) UIButton *selectVillageBtn;

@property (strong, nonatomic) NSMutableArray *datas;

@property (strong, nonatomic) UIScrollView *headView;

@property (strong, nonatomic) NSMutableArray *selectButtons;

@end

@implementation ImproveInfoViewController
{
    int cid;
    NSString *name;
    NSInteger headPosition;
}

+(void)show : (BaseViewController *)controller tel : (NSString *)tel
{
    ImproveInfoViewController *targetController = [[ImproveInfoViewController alloc]init];
    targetController.tel = tel;
    [controller.navigationController pushViewController:targetController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    headPosition = -1;
    cid = -1;
    _datas = [[NSMutableArray alloc]init];
    _selectButtons = [[NSMutableArray alloc]init];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initView];
}

#pragma mark 初始化视图
-(void)initView
{
    [self initNavigationBar];
    [self initMainView];
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:YES];
    [self.navBar setTitle:@"完善资料"];
}

-(void)initMainView
{
    UIView *view = [[UIView alloc]init];
    view.frame = Default_Frame;
    [self.view addSubview:view];
    
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"完善资料，有助于您更好的行使投票和发言权";
    tipLabel.textColor = [UIColor colorWithRed:155/255 green:155/255 blue:155/255 alpha:1.0f];
    tipLabel.font = [UIFont systemFontOfSize:11.0f];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame =CGRectMake(0, 0, SCREEN_WIDTH, 28);
    [view addSubview:tipLabel];

    //姓名
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    view1.frame = CGRectMake(0, 28, SCREEN_WIDTH, 42);
    [view addSubview:view1];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"居民姓名";
    nameLabel.font = [UIFont systemFontOfSize:13.0f];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.frame = CGRectMake(15, 0, nameLabel.contentSize.width, 42);
    [view1 addSubview:nameLabel];
    
    _nameTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH -100, 42)];
    _nameTextView.placeholder = @"请填写您的真实姓名";
    _nameTextView.font = [UIFont systemFontOfSize:13.0f];
    _nameTextView.backgroundColor = [UIColor clearColor];
    _nameTextView.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6];
    _nameTextView.returnKeyType = UIReturnKeyNext;
    _nameTextView.delegate = self;
    [_nameTextView becomeFirstResponder];
    [view1 addSubview:_nameTextView];

    
    //身份证号
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    view2.frame = CGRectMake(0, 28 + 42, SCREEN_WIDTH, 42);
    [view addSubview:view2];
    
    UILabel *cardIDLabel = [[UILabel alloc]init];
    cardIDLabel.text = @"身份证号";
    cardIDLabel.font = [UIFont systemFontOfSize:13.0f];
    cardIDLabel.textColor = [UIColor blackColor];
    cardIDLabel.textAlignment = NSTextAlignmentCenter;
    cardIDLabel.frame = CGRectMake(15, 0, cardIDLabel.contentSize.width, 42);
    [view2 addSubview:cardIDLabel];
    
    _cardIDTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH -100, 42)];
    _cardIDTextView.placeholder = @"有助于我们核实您的真实身份";
    _cardIDTextView.font = [UIFont systemFontOfSize:13.0f];
    _cardIDTextView.backgroundColor = [UIColor clearColor];
    _cardIDTextView.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6];
    _cardIDTextView.returnKeyType = UIReturnKeyNext;
    _cardIDTextView.delegate = self;
    [view2 addSubview:_cardIDTextView];
    
    
    UIView *divideLine1 = [[UIView alloc]init];
    divideLine1.backgroundColor = BACKGROUND_COLOR;
    divideLine1.frame = CGRectMake(0, 28 + 42, SCREEN_WIDTH, 1);
    [view addSubview:divideLine1];
    
    
    
    //选择小区
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor whiteColor];
    view3.frame = CGRectMake(0, 28 + 42 *2+10, SCREEN_WIDTH, 42);
    [view addSubview:view3];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.text = @"选择小区";
    addressLabel.font = [UIFont systemFontOfSize:13.0f];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.frame = CGRectMake(15, 0, addressLabel.contentSize.width, 42);
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [view3 addSubview:addressLabel];
    
    _selectVillageBtn = [[UIButton alloc]init];
    _selectVillageBtn.backgroundColor = [UIColor clearColor];
    _selectVillageBtn.frame = CGRectMake(100, 0,SCREEN_WIDTH - 100, 40);
    _selectVillageBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_selectVillageBtn setTitle:@"请选择小区 ▼" forState:UIControlStateNormal];
    [_selectVillageBtn setTitleColor:[ColorUtil colorWithHexString:@"#000000" alpha:0.6] forState:UIControlStateNormal];
    _selectVillageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;

    [_selectVillageBtn addTarget:self action:@selector(selectVillage) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:_selectVillageBtn];
    
    
    //门牌号
    UIView *view4 = [[UIView alloc]init];
    view4.backgroundColor = [UIColor whiteColor];
    view4.frame = CGRectMake(0, 28 + 42 *3+10, SCREEN_WIDTH, 42);
    [view addSubview:view4];
    
    UILabel *gateHouseLabel = [[UILabel alloc]init];
    gateHouseLabel.text = @"门牌号";
    gateHouseLabel.font = [UIFont systemFontOfSize:13.0f];
    gateHouseLabel.textColor = [UIColor blackColor];
    gateHouseLabel.frame = CGRectMake(15, 0, gateHouseLabel.contentSize.width, 42);
    gateHouseLabel.textAlignment = NSTextAlignmentCenter;
    [view4 addSubview:gateHouseLabel];
    

    _gateHouseTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-100, 42)];
    _gateHouseTextView.placeholder = @"请填写详细住址，例如A101";
    _gateHouseTextView.font = [UIFont systemFontOfSize:13.0f];
    _gateHouseTextView.backgroundColor = [UIColor clearColor];
    _gateHouseTextView.textColor =[ColorUtil colorWithHexString:@"#000000" alpha:0.6];
    _gateHouseTextView.returnKeyType = UIReturnKeyGo;
    _gateHouseTextView.delegate = self;
    [view4 addSubview:_gateHouseTextView];
    
    
    UIView *divideLine2 = [[UIView alloc]init];
    divideLine2.backgroundColor = BACKGROUND_COLOR;
    divideLine2.frame = CGRectMake(0, 28 + 42 *3 +10, SCREEN_WIDTH, 1);
    [view addSubview:divideLine2];
    
    
    _headView = [[UIScrollView alloc]init];
    _headView.showsVerticalScrollIndicator = NO;
    _headView.showsHorizontalScrollIndicator = NO;
    _headView.frame = CGRectMake(0, 28 + 42 *4 +20, SCREEN_WIDTH, 80);
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.contentSize = CGSizeMake(15*6 + 60 * 5, 80);
    _headView.hidden = YES;
    [view addSubview:_headView];
    

    UIButton *commitBtn = [[UIButton alloc]init];
    commitBtn.frame = CGRectMake(15, 28 + 42 *4 +10 +120, SCREEN_WIDTH-30, 48);
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    commitBtn.layer.masksToBounds=YES;
    commitBtn.layer.cornerRadius = 4;
    [commitBtn addTarget:self action:@selector(requestCommit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commitBtn];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if(textView == _nameTextView)
        {
            [_cardIDTextView becomeFirstResponder];
        }
        else if(textView == _cardIDTextView)
        {
            [_gateHouseTextView becomeFirstResponder];
        }
        else if(textView == _gateHouseTextView)
        {
            [self requestCommit];
        }
        return NO;
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == _cardIDTextView)
    {
        NSString *cardId= _cardIDTextView.text;
        if(cardId.length == 15)
        {
            [_headView setHidden:NO];
            int gender = [[cardId substringWithRange:NSMakeRange(14, 1)] integerValue];
            [self showHeadView:gender];
        }
        else if(cardId.length == 18)
        {
            [_headView setHidden:NO];
            int gender = [[cardId substringWithRange:NSMakeRange(16, 1)] integerValue];
            [self showHeadView:gender];
        }
        else
        {
            [_headView setHidden:YES];
        }
    }
}

-(void)showHeadView : (int)gender
{
    for(UIView *view in _headView.subviews)
    {
        [view removeFromSuperview];
    }
    [_selectButtons removeAllObjects];
    
    NSArray *array;
    gender = gender %2;
    if(gender == 0)
    {
        array = @[@"ic_girl_a",@"ic_girl_b",@"ic_girl_c",@"ic_girl_d",@"ic_girl_e"];
    }
    else
    {
        array = @[@"ic_boy_a",@"ic_boy_b",@"ic_boy_c",@"ic_boy_d",@"ic_boy_e"];
    }
    for(int i=0 ; i<[array count]; i++)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(OnHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(15 * (i+1)+ 60 * i, 10, 60, 60);
        [_headView addSubview:button];
        
        UIButton *selectBtn = [[UIButton alloc]init];
        [selectBtn setImage:[UIImage imageNamed:@"ic_chose"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"ic_chose_in"] forState:UIControlStateSelected];
        selectBtn.frame = CGRectMake(35, 35, 20, 20);
        [button addSubview:selectBtn];
        [_selectButtons addObject:selectBtn];

    }
}

-(UIButton *)buildHeadButton : (UIImage *)image
{
    UIButton *button = [[UIButton alloc]init];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

-(void)OnHeadClick : (id)sender
{
    UIButton *button = sender;
    NSInteger position = button.tag;
    if(!IS_NS_COLLECTION_EMPTY(_selectButtons))
    {
        for(UIButton *temp in _selectButtons)
        {
            [temp setSelected:NO];
        }
        [[_selectButtons objectAtIndex:position] setSelected:YES];
        headPosition = position;
    }
}

#pragma mark 点击选择小区
-(void)selectVillage
{
    [_nameTextView resignFirstResponder];
    [_cardIDTextView resignFirstResponder];
    [_gateHouseTextView resignFirstResponder];
    
    VillageListView *view = [[VillageListView alloc]init];
    view.delegate = self;
    [self.view addSubview:view];
}

#pragma mark 选择小区回调
-(void)OnSelectVillage:(VillageModel *)model
{
    cid = model.villageId;
    name= model.name;
    [_selectVillageBtn setTitle:model.name forState:UIControlStateNormal];
}


#pragma mark 触摸其他区域
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_nameTextView isExclusiveTouch] || ![_cardIDTextView isExclusiveTouch] || ![_gateHouseTextView isExclusiveTouch]) {
        [_nameTextView resignFirstResponder];
        [_cardIDTextView resignFirstResponder];
        [_gateHouseTextView resignFirstResponder];

    }
}


#pragma mark 对话框监听
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [HomeViewController show:self];
}



#pragma mark 提交审核
-(void)requestCommit{
    [_nameTextView resignFirstResponder];
    [_cardIDTextView resignFirstResponder];
    [_gateHouseTextView resignFirstResponder];
    
    if(IS_NS_STRING_EMPTY(_nameTextView.text))
    {
        [DialogHelper showWarnTips:@"请填写您的姓名"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_cardIDTextView.text))
    {
        [DialogHelper showWarnTips:@"请填写您的身份证号码"];
        return;
    }
    if(![AppUtil checkUserIdCard:_cardIDTextView.text])
    {
        [DialogHelper showWarnTips:@"请检查您身份证号码是否有误"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_gateHouseTextView.text))
    {
        [DialogHelper showWarnTips:@"请填写您的门牌号"];
        return;
    }
    if(cid == -1)
    {
        [DialogHelper showWarnTips:@"请选择小区"];
        return;
    }
    if(headPosition == -1)
    {
        [DialogHelper showWarnTips:@"请选择一个喜欢的头像"];
        return;

    }
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"tel"] = _tel;
    params[@"cid"] = [NSString stringWithFormat:@"%d",cid];
    params[@"name"] = _nameTextView.text;
    params[@"idcard"] = _cardIDTextView.text;
    params[@"gatehouse"] = _gateHouseTextView.text;
    params[@"token"] = [[Account sharedAccount]getToken];
    params[@"avatar"] = [NSString stringWithFormat:@"%d",headPosition];
    
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:cid forKey:VillageID];
    [userDefault setObject:name forKey:VillageName];
    [manager GET:Request_Commit parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                       @"恭喜您" message:@"提交资料成功，我们会在1-3个工作日审核，请耐心等待" delegate:self
                                                      cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
             [alertView show];
        
         }
         else
         {
             [DialogHelper showFailureAlertSheet:@"提交失败，请重试"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [DialogHelper showFailureAlertSheet:@"提交失败，请重试"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
        
}

-(void)OnLeftClickCallback
{
    [_nameTextView resignFirstResponder];
    [_cardIDTextView resignFirstResponder];
    [_gateHouseTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}




@end
