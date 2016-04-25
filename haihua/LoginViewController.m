//
//  LoginViewController.m
//  haihua
//
//  Created by by.huang on 16/3/23.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "LoginViewController.h"
#import "UIPlaceholderTextView.h"
#import "AppUtil.h"
#import "DialogHelper.h"
#import "ImproveInfoViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "CommentViewController.h"
#import "Account.h"
#import "MiPushSDK.h"


@interface LoginViewController ()

@property (strong, nonatomic)UIPlaceholderTextView *phoneTextView;

@property (strong, nonatomic)UIPlaceholderTextView *passwordTextView;

@property (strong, nonatomic)UIButton *sendButton;

@end

@implementation LoginViewController
{
    int count;
}


+(void)show : (BaseViewController *)controller
{
    LoginViewController *targetController = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetController];
    [controller presentViewController:nav animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    count = 60;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_phoneTextView addObserver];
    [_passwordTextView addObserver];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_phoneTextView removeobserver];
    [_passwordTextView removeobserver];
}

-(void)initView
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initNavigationBar];
    [self initLoginView];
    
}

-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [self.navBar setTitle:@"登陆"];
}

-(void)initLoginView
{
    UIView *loginView =[[UIView alloc]init];
    loginView.frame = Default_Frame;
    [self.view addSubview:loginView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"使用手机号登陆";
    titleLabel.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.8f];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.frame = CGRectMake((SCREEN_WIDTH - titleLabel.contentSize.width)/2, NavigationBar_HEIGHT , titleLabel.contentSize.width, titleLabel.contentSize.height);
    [loginView addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = LINE_COLOR;
    topLine.frame = CGRectMake(15, titleLabel.frame.origin.y + titleLabel.contentSize.height + 30, SCREEN_WIDTH - 30, 0.5);
    [loginView addSubview:topLine];
    
    
    UIView *centerLine = [[UIView alloc]init];
    centerLine.backgroundColor = LINE_COLOR;
    centerLine.frame = CGRectMake(15, titleLabel.frame.origin.y + titleLabel.contentSize.height + 70, SCREEN_WIDTH - 30, 0.5);
    [loginView addSubview:centerLine];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = LINE_COLOR;
    bottomLine.frame = CGRectMake(15, titleLabel.frame.origin.y + titleLabel.contentSize.height + 110, SCREEN_WIDTH - 30, 0.5);
    [loginView addSubview:bottomLine];
 
    UIView *divideLine = [[UIView alloc]init];
    divideLine.backgroundColor = LINE_COLOR;
    divideLine.frame = CGRectMake(90, titleLabel.frame.origin.y + titleLabel.contentSize.height + 30, 0.5, 40);
    [loginView addSubview:divideLine];
    
    UILabel *areaLabel = [[UILabel alloc]init];
    areaLabel.text = @"+86";
    areaLabel.font = [UIFont systemFontOfSize:16.0f];
    areaLabel.textColor = [UIColor blackColor];
    areaLabel.frame = CGRectMake(30, titleLabel.frame.origin.y + titleLabel.contentSize.height + 40, areaLabel.contentSize.width, areaLabel.contentSize.height);
    [loginView addSubview:areaLabel];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.text = @"验证码";
    passwordLabel.font = [UIFont systemFontOfSize:16.0f];
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.frame = CGRectMake(30, titleLabel.frame.origin.y + titleLabel.contentSize.height + 80, passwordLabel.contentSize.width, passwordLabel.contentSize.height);
    [loginView addSubview:passwordLabel];
    
    _phoneTextView =[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(divideLine.x + 10, topLine.y+2, 130 , 40)];
    _phoneTextView.backgroundColor = [UIColor clearColor];
    _phoneTextView.font = [UIFont systemFontOfSize:16.0f];
    _phoneTextView.textColor = [UIColor blackColor];
    _phoneTextView.placeholder = @"请填写手机号码";
    _phoneTextView.keyboardType = UIKeyboardTypePhonePad;
    [_phoneTextView becomeFirstResponder];
    [loginView addSubview:_phoneTextView];
    
    _passwordTextView =[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(divideLine.x + 10, topLine.y+42, SCREEN_WIDTH , 40)];
    _passwordTextView.backgroundColor = [UIColor clearColor];
    _passwordTextView.font = [UIFont systemFontOfSize:16.0f];
    _passwordTextView.textColor = [UIColor blackColor];
    _passwordTextView.placeholder = @"请填写验证码";
    _passwordTextView.keyboardType = UIKeyboardTypePhonePad;
    [loginView addSubview:_passwordTextView];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.frame = CGRectMake(30, bottomLine.y + 20, SCREEN_WIDTH-60, 50);
    [loginBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius = 6;
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginBtn];
    
    _sendButton = [[UIButton alloc]init];
    [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sendButton.layer.masksToBounds=YES;
    _sendButton.layer.cornerRadius = 4;
    [_sendButton setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    _sendButton.frame = CGRectMake(divideLine.x + 140, topLine.y+5, 80, 30);
    [_sendButton addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_sendButton];
}

-(void)sendMsg
{
    
    [_phoneTextView resignFirstResponder];
    [_passwordTextView resignFirstResponder];
    if([AppUtil checkTel:_phoneTextView.text])
    {
        [self reqestVerifyCode];
        [_sendButton setEnabled:NO];
        [self countTime];
        [_passwordTextView becomeFirstResponder];
    }
}

-(void)countTime
{
    count --;
    if(count == 0)
    {
        [_sendButton setEnabled:YES];
        [_sendButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        count = 60;
        return;
    }
    [_sendButton setTitle:[NSString stringWithFormat:@"%d秒后重发",count] forState:UIControlStateNormal];
    [self performSelector:@selector(countTime) withObject:nil afterDelay:1];
}

-(void)login
{

    [_phoneTextView resignFirstResponder];
    [_passwordTextView resignFirstResponder];
    if([AppUtil checkTel:_phoneTextView.text])
    {
        if(IS_NS_STRING_EMPTY(_passwordTextView.text))
        {
            [DialogHelper showWarnTips:@"验证码不能为空"];
            return;
        }
        else
        {
            [self requestLogin];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_phoneTextView isExclusiveTouch] || ![_passwordTextView isExclusiveTouch]) {
        [_phoneTextView resignFirstResponder];
        [_passwordTextView resignFirstResponder];
    }
}

-(void)OnLeftClickCallback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  @from                    v1.1.1
 *  @brief                   获取验证码(Get verification code)
 *
 *  @param method            获取验证码的方法(The method of getting verificationCode)
 *  @param phoneNumber       电话号码(The phone number)
 *  @param zone              区域号，不要加"+"号(Area code)
 *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
 *  @param result            请求结果回调(Results of the request)
 */
-(void)reqestVerifyCode
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTextView.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error)
        {
            [DialogHelper showSuccessTips:@"获取验证码成功"];
        }
        else {
            [DialogHelper showTips:@"获取验证码失败"];
        }
    }];
}


-(void)requestLogin
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tel"] = _phoneTextView.text;
    params[@"code"] = _passwordTextView.text;
    params[@"cid"] = [NSString stringWithFormat:@"%d",(int)[userDefaults integerForKey:VillageID]];
        [manager POST:Request_VerifyCode parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
         if(model.code == SUCCESS_CODE)
         {
             
//             Account *account = [[Account alloc]init];
//             account.uid = model.uid;
//             account.token = model.token;
//             // 设置别名
//             [MiPushSDK setAlias:account.uid];
//             // 订阅内容
//             [MiPushSDK subscribe:[NSString stringWithFormat:@"%d",(int)[userDefaults integerForKey:VillageID]]];
//             // 设置帐号
////             [MiPushSDK setAccount:@"account"];
//             [[Account sharedAccount] savaAccount:account];
//             [MainViewController show:self villageId:[userDefaults integerForKey:VillageID] name:[userDefaults objectForKey:VillageName]];
             Account *account = [[Account alloc]init];
             account.uid = model.uid;
             account.token = model.token;
             [[Account sharedAccount] savaAccount:account];
             [ImproveInfoViewController show:self tel:_phoneTextView.text];
         }
         else if(model.code == SUCCESS_NEED_VERIFY)
         {
             Account *account = [[Account alloc]init];
             account.uid = model.uid;
             account.token = model.token;
             [[Account sharedAccount] savaAccount:account];
             [ImproveInfoViewController show:self tel:_phoneTextView.text];
         }
         else
         {
             [DialogHelper showFailureAlertSheet:@"登陆失败"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [DialogHelper showFailureAlertSheet:@"登陆失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

     }];
}


@end
