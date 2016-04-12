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
#import "VillageListViewController.h"
#import "DialogHelper.h"
#import "Account.h"
#import "MainViewController.h"

@interface ImproveInfoViewController ()

@property (strong, nonatomic) UIPlaceholderTextView *nameTextView;

@property (strong, nonatomic) UIPlaceholderTextView *cardIDTextView;

@property (strong, nonatomic) UIPlaceholderTextView *gateHouseTextView;

@property (strong, nonatomic) UIButton *selectVillageBtn;

@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ImproveInfoViewController
{
    int cid;
    NSString *name;
}

+(void)show : (BaseViewController *)controller tel : (NSString *)tel
{
    ImproveInfoViewController *targetController = [[ImproveInfoViewController alloc]init];
    targetController.tel = tel;
    [controller.navigationController pushViewController:targetController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cid = -1;
    _datas = [[NSMutableArray alloc]init];
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
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = [UIFont systemFontOfSize:14.0f];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.frame =CGRectMake(0, 30, SCREEN_WIDTH, tipLabel.contentSize.height);
    [view addSubview:tipLabel];

    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = LINE_COLOR;
    topLine.frame = CGRectMake(15, tipLabel.frame.origin.y + tipLabel.contentSize.height + 30, SCREEN_WIDTH - 30, 0.5);
    [view addSubview:topLine];
    
    UIView *centerLine1 = [[UIView alloc]init];
    centerLine1.backgroundColor = LINE_COLOR;
    centerLine1.frame = CGRectMake(15, tipLabel.frame.origin.y + tipLabel.contentSize.height + 70, SCREEN_WIDTH - 30, 0.5);
    [view addSubview:centerLine1];
    
    UIView *centerLine2 = [[UIView alloc]init];
    centerLine2.backgroundColor = LINE_COLOR;
    centerLine2.frame = CGRectMake(15, tipLabel.frame.origin.y + tipLabel.contentSize.height + 110, SCREEN_WIDTH - 30, 0.5);
    [view addSubview:centerLine2];
    
    UIView *centerLine3 = [[UIView alloc]init];
    centerLine3.backgroundColor = LINE_COLOR;
    centerLine3.frame = CGRectMake(15, tipLabel.frame.origin.y + tipLabel.contentSize.height + 150, SCREEN_WIDTH - 30, 0.5);
    [view addSubview:centerLine3];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = LINE_COLOR;
    bottomLine.frame = CGRectMake(15, tipLabel.frame.origin.y + tipLabel.contentSize.height + 190, SCREEN_WIDTH - 30, 0.5);
    [view addSubview:bottomLine];
    
    
    UIView *divideLine = [[UIView alloc]init];
    divideLine.backgroundColor = LINE_COLOR;
    divideLine.frame = CGRectMake(90, tipLabel.frame.origin.y + tipLabel.contentSize.height + 30, 0.5, 160);
    [view addSubview:divideLine];
    
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"您的姓名";
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.frame = CGRectMake(20, tipLabel.frame.origin.y + tipLabel.contentSize.height + 40, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [view addSubview:nameLabel];
    
    UILabel *cardIDLabel = [[UILabel alloc]init];
    cardIDLabel.text = @"身份证号";
    cardIDLabel.font = [UIFont systemFontOfSize:15.0f];
    cardIDLabel.textColor = [UIColor blackColor];
    cardIDLabel.frame = CGRectMake(20, tipLabel.frame.origin.y + tipLabel.contentSize.height + 80, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [view addSubview:cardIDLabel];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.text = @"选择小区";
    addressLabel.font = [UIFont systemFontOfSize:15.0f];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.frame = CGRectMake(20, tipLabel.frame.origin.y + tipLabel.contentSize.height + 120, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [view addSubview:addressLabel];
    
    UILabel *gateHouseLabel = [[UILabel alloc]init];
    gateHouseLabel.text = @"门牌号";
    gateHouseLabel.font = [UIFont systemFontOfSize:15.0f];
    gateHouseLabel.textColor = [UIColor blackColor];
    gateHouseLabel.frame = CGRectMake(20, tipLabel.frame.origin.y + tipLabel.contentSize.height + 160, nameLabel.contentSize.width, nameLabel.contentSize.height);
    [view addSubview:gateHouseLabel];
    
    
    _nameTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(divideLine.x + 10, topLine.y+2, SCREEN_WIDTH -divideLine.x - 10 - 15, 40)];
    _nameTextView.placeholder = @"请填写您的真实姓名";
    _nameTextView.font = [UIFont systemFontOfSize:15.0f];
    _nameTextView.backgroundColor = [UIColor clearColor];
    _nameTextView.textColor = [UIColor blackColor];
    _nameTextView.returnKeyType = UIReturnKeyNext;
    _nameTextView.delegate = self;
    [_nameTextView becomeFirstResponder];
    [view addSubview:_nameTextView];
    
    
    _cardIDTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(divideLine.x + 10, centerLine1.y+2, SCREEN_WIDTH -divideLine.x - 10 - 15, 40)];
    _cardIDTextView.placeholder = @"有助于我们核实您的真实身份";
    _cardIDTextView.font = [UIFont systemFontOfSize:15.0f];
    _cardIDTextView.backgroundColor = [UIColor clearColor];
    _cardIDTextView.textColor = [UIColor blackColor];
    _cardIDTextView.returnKeyType = UIReturnKeyNext;
    _cardIDTextView.delegate = self;
    [view addSubview:_cardIDTextView];
    
    _gateHouseTextView = [[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(divideLine.x + 10, centerLine3.y+2, SCREEN_WIDTH -divideLine.x - 10 - 15, 40)];
    _gateHouseTextView.placeholder = @"请填写详细住址，例如A101";
    _gateHouseTextView.font = [UIFont systemFontOfSize:15.0f];
    _gateHouseTextView.backgroundColor = [UIColor clearColor];
    _gateHouseTextView.textColor = [UIColor blackColor];
    _gateHouseTextView.returnKeyType = UIReturnKeyGo;
    _gateHouseTextView.delegate = self;
    [view addSubview:_gateHouseTextView];
    
    _selectVillageBtn = [[UIButton alloc]init];
    _selectVillageBtn.backgroundColor = [UIColor clearColor];
    _selectVillageBtn.frame = CGRectMake(divideLine.x + 10, centerLine2.y, SCREEN_WIDTH -divideLine.x - 10 - 15, 40);
    _selectVillageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_selectVillageBtn setTitle:@"请选择小区 ▼" forState:UIControlStateNormal];
    [_selectVillageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectVillageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;

    [_selectVillageBtn addTarget:self action:@selector(selectVillage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_selectVillageBtn];


    UIButton *commitBtn = [[UIButton alloc]init];
    commitBtn.frame = CGRectMake(30, bottomLine.y + 20, SCREEN_WIDTH-60, 50);
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    commitBtn.layer.masksToBounds=YES;
    commitBtn.layer.cornerRadius = 6;
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
#pragma mark 点击选择小区
-(void)selectVillage
{
    
    VillageListViewController *controller = [[VillageListViewController alloc]init];
    controller.isFromImprove = YES;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 选择小区回调
-(void)OnSelectVillage:(int)villageId name:(NSString *)villageName
{
    cid = villageId;
    name= villageName;
    [_selectVillageBtn setTitle:villageName forState:UIControlStateNormal];
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
    [MainViewController show:self villageId:cid name:name];
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
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"tel"] = _tel;
    params[@"cid"] = [NSString stringWithFormat:@"%d",cid];
    params[@"name"] = _nameTextView.text;
    params[@"idcard"] = _cardIDTextView.text;
    params[@"gatehouse"] = _gateHouseTextView.text;
    params[@"token"] = [[Account sharedAccount]getToken];
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




@end
