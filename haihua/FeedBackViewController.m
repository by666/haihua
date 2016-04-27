//
//  FeedBackViewController.m
//  haihua
//
//  Created by by.huang on 16/3/31.
//  Copyright © 2016年 by.huang. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Account.h"
#import "AppUtil.h"
#import "DialogHelper.h"
#import "UIPlaceholderTextView.h"

@interface FeedBackViewController ()

@property (strong ,nonatomic) UIPlaceholderTextView *titleTextView;

@property (strong, nonatomic) UIPlaceholderTextView *contentTextView;

@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation FeedBackViewController


+(void)show : (BaseViewController *)controller
{
    FeedBackViewController *target = [[FeedBackViewController alloc]init];
    [controller presentViewController:target animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self initView];
}


#pragma mark 初始化视图
-(void)initView
{
    _images = [[NSMutableArray alloc]init];
    _buttons = [[NSMutableArray alloc]init];
    [self initNavigationBar];
    [self initMainView];
}


-(void)initNavigationBar
{
    [self showNavigationBar];
    [self.navBar.leftBtn setHidden:NO];
    self.navBar.delegate = self;
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [self.navBar setTitle:@"发布意见"];
}

-(void)initMainView
{
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0,  NavigationBar_HEIGHT +StatuBar_HEIGHT, SCREEN_WIDTH, 160 + 100 + 20);
    [self.view addSubview:topView];
    
    _titleTextView = [[UIPlaceholderTextView alloc]init];
    _titleTextView.placeholder = @"标题";
    _titleTextView.font = [UIFont systemFontOfSize:13.0f];
    _titleTextView.backgroundColor = [UIColor whiteColor];
    _titleTextView.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _titleTextView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 40);
    [topView addSubview:_titleTextView];
    
    _contentTextView = [[UIPlaceholderTextView alloc]init];
    _contentTextView.placeholder = @"描述一下你想说的";
    _contentTextView.font = [UIFont systemFontOfSize:13.0f];
    _contentTextView.textColor = LINE_COLOR;
    _contentTextView.textColor = [ColorUtil colorWithHexString:@"#000000" alpha:0.6f];
    _contentTextView.frame = CGRectMake(15 , 40, SCREEN_WIDTH-30, 120);
    [topView addSubview:_contentTextView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.frame = CGRectMake(15, 40, SCREEN_WIDTH - 30, 0.5);
    [topView addSubview:lineView];
    
    
    for(int i = 0 ;i < 3 ;i ++)
    {
        UIImageView *button = [[UIImageView alloc]init];
        button.tag = i;
        button.userInteractionEnabled = YES;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor lightGrayColor];
        button.image = [UIImage imageNamed:@"ic_add"];
        button.frame = CGRectMake(15 * (i+1)  + 80 * i, 180, 80, 80);
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnButtonClick:)];
        [button addGestureRecognizer:recognizer];
        [topView addSubview:button];
        [_buttons addObject:button];
    }
    
    
    UIButton *commitBtn = [[UIButton alloc]init];
    commitBtn.frame = CGRectMake(15,  360, SCREEN_WIDTH - 30, 50);
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"确定发布" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    commitBtn.layer.masksToBounds=YES;
    commitBtn.layer.cornerRadius = 6;
    [commitBtn addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:commitBtn];

}




#pragma mark 拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        __weak UIView *view = [UIApplication sharedApplication].keyWindow;
        __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            [hud hide:YES];
        }];
    }
    else {
        [DialogHelper showWarnTips:@"无法使用相机功能!"];
    }
}

#pragma mark 选取相册
- (void)takeAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
     
        [_images addObject:originalImage];
        for(int i = 0; i< [_images count]; i++)
        {
            ((UIImageView *)[_buttons objectAtIndex:i]).image = [_images objectAtIndex:i] ;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark 点击返回事件
-(void)OnLeftClickCallback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)OnButtonClick : (id)sender
{
    if (![_titleTextView isExclusiveTouch] || ![_contentTextView isExclusiveTouch]) {
        [_titleTextView resignFirstResponder];
        [_contentTextView resignFirstResponder];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"从相册选取"];
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self takePhoto];
    }
    else if(buttonIndex == 2)
    {
        [self takeAlbum];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_titleTextView isExclusiveTouch] || ![_contentTextView isExclusiveTouch]) {
        [_titleTextView resignFirstResponder];
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark 创建md5s
-(NSString *)createMd5s
{
    NSString *md5s=@"";
    for(UIImage *image in _images)
    {
        md5s = [md5s stringByAppendingString:[NSString stringWithFormat:@"%@,",[AppUtil imageMD5:image]]];
    }
    if(!IS_NS_STRING_EMPTY(md5s))
    {
        md5s = [md5s substringToIndex:md5s.length -1];
    }
    return md5s;
}



#pragma mark 提交意见反馈
-(void)upload
{
    if(IS_NS_STRING_EMPTY(_titleTextView.text))
    {
        [DialogHelper showWarnTips:@"请填写标题"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_contentTextView.text))
    {
        [DialogHelper showWarnTips:@"请填写内容"];
        return;
    }
    __weak MBProgressHUD *hua = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *md5s = [self createMd5s];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:Request_FeedBack parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(!IS_NS_COLLECTION_EMPTY(_images))
        {
            for(UIImage *image in _images)
            {
                [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                            name:@"files"
                                        fileName:@"image" mimeType:@"image/jpeg"];
            }
        }
        [formData appendPartWithFormData:[[[Account sharedAccount]getTel] dataUsingEncoding:NSUTF8StringEncoding] name:@"tel"];
        [formData appendPartWithFormData:[[[Account sharedAccount]getToken] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        [formData appendPartWithFormData:[_titleTextView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        [formData appendPartWithFormData:[_contentTextView.text dataUsingEncoding:NSUTF8StringEncoding ] name:@"content"];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        int cid = [userdefault integerForKey:VillageID];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",cid] dataUsingEncoding:NSUTF8StringEncoding ] name:@"cid"];

        [formData appendPartWithFormData:[md5s dataUsingEncoding:NSUTF8StringEncoding ] name:@"md5s"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:nil
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          [DialogHelper showWarnTips:@"上传失败,请重试"];
                      } else {
                          ResponseModel *model = [ResponseModel mj_objectWithKeyValues:responseObject];
                          if(model.code == SUCCESS_CODE)
                          {
                              [DialogHelper showSuccessTips:@"上传成功，感谢您的支持"];

                          }
                          else{
                              [DialogHelper showWarnTips:@"上传失败,请重试"];
                          }
                      }
                      [hua hide:YES];

                  }];
    
    [uploadTask resume];
}
@end
