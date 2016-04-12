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

@interface FeedBackViewController ()

@property (strong ,nonatomic) UITextView *titleTextView;

@property (strong, nonatomic) UITextView *contentTextView;

@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation FeedBackViewController


+(void)show : (BaseViewController *)controller
{
    FeedBackViewController *target = [[FeedBackViewController alloc]init];
    [controller.navigationController pushViewController:target animated:YES];
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
    [self.navBar.leftBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.navBar setTitle:@"曝光反馈"];
}

-(void)initMainView
{
    UILabel *titleLabel =[[UILabel alloc]init];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.frame = CGRectMake(15, NavigationBar_HEIGHT +StatuBar_HEIGHT + 30 + (30 - titleLabel.contentSize.height)/2, titleLabel.contentSize.width, titleLabel.contentSize.height);
    [self.view addSubview:titleLabel];
    
    
    _titleTextView = [[UITextView alloc]init];
    _titleTextView.font = [UIFont systemFontOfSize:13.0f];
    _titleTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    _titleTextView.layer.cornerRadius = 4;
    _titleTextView.layer.borderWidth = 0.5;
    _titleTextView.layer.masksToBounds = YES;
    _titleTextView.frame = CGRectMake(15 + titleLabel.contentSize.width + 10, NavigationBar_HEIGHT +StatuBar_HEIGHT + 30, SCREEN_WIDTH - 30 -(titleLabel.contentSize.width + 10), 30);
    [self.view addSubview:_titleTextView];
    
    
    UILabel *contentLabel =[[UILabel alloc]init];
    contentLabel.text = @"内容";
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.frame = CGRectMake(15, NavigationBar_HEIGHT +StatuBar_HEIGHT + 30 + (30 - contentLabel.contentSize.height)/2 + 50, contentLabel.contentSize.width, contentLabel.contentSize.height);
    [self.view addSubview:contentLabel];
    
    
    _contentTextView = [[UITextView alloc]init];
    _contentTextView.font = [UIFont systemFontOfSize:13.0f];
    _contentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    _contentTextView.layer.cornerRadius = 4;
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.frame = CGRectMake(15 + titleLabel.contentSize.width + 10, NavigationBar_HEIGHT +StatuBar_HEIGHT + 30 + 50, SCREEN_WIDTH - 30 -(titleLabel.contentSize.width + 10), 120);
    [self.view addSubview:_contentTextView];
    
    
    UILabel *imageLabel =[[UILabel alloc]init];
    imageLabel.text = @"附件";
    imageLabel.font = [UIFont systemFontOfSize:14.0f];
    imageLabel.textColor = [UIColor blackColor];
    imageLabel.frame = CGRectMake(15, NavigationBar_HEIGHT +StatuBar_HEIGHT + 30 + (30 - contentLabel.contentSize.height)/2 + 190, imageLabel.contentSize.width, imageLabel.contentSize.height);
    [self.view addSubview:imageLabel];
    
    
    for(int i = 0 ;i < 3 ;i ++)
    {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor lightGrayColor];
        [button setImage:[UIImage imageNamed:@"defaultimg"] forState:UIControlStateNormal];
        button.frame = CGRectMake(15 + titleLabel.contentSize.width + 10 + 70 * i, _contentTextView.y + 140, 60, 60);
        [button addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_buttons addObject:button];
    }
    
    
    UIButton *commitBtn = [[UIButton alloc]init];
    commitBtn.frame = CGRectMake((SCREEN_WIDTH - 120)/2,  _contentTextView.y + 220, 120, 40);
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[AppUtil imageWithColor:[ColorUtil colorWithHexString:@"#2d90ff" alpha:0.6f]] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
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
        [self.navigationController presentViewController:picker animated:YES completion:^{
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
    [self.navigationController presentViewController:picker animated:YES completion:nil];
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
            [[_buttons objectAtIndex:i] setImage:[_images objectAtIndex:i] forState:UIControlStateNormal];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark 点击返回事件
-(void)OnLeftClickCallback
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)OnButtonClick : (id)sender
{
    
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
                      }
                      [hua hide:YES];

                  }];
    
    [uploadTask resume];
}
@end
