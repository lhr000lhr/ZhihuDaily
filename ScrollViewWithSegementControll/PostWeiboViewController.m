//
//  PostWeiboViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "PostWeiboViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface PostWeiboViewController ()

@end

@implementation PostWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//- (void)viewWillAppear: (BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = YES;
//
//}
//- (void)viewWillDisappear: (BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = NO;
//
//}

- (void)tapImage:(UITapGestureRecognizer *)tap
{

    [self.textField resignFirstResponder];
    UIImageView *view = (UIImageView *)[tap view];
    NSMutableArray *photos = [NSMutableArray new];

    MJPhoto *photo = [[MJPhoto alloc] init];
    // photo.url = [NSURL URLWithString:[eachContent objectForKey:@"text"]]; // 图片路径
    photo.image = view.image;
    photo.srcImageView = view;// 来源于哪个UIImageView
    [photos addObject:photo];

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    [browser show];





}

-(void)viewWillDisappear:(BOOL)animated
{

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"imageData"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"textFieldContent"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textField becomeFirstResponder];


    SinaWeibo *sinaWeibo = [self sinaweibo];
    if (![sinaWeibo isAuthValid]) { ////// 检查是否登录
        
        self.doneButton.enabled = NO;
    
    }
    self.imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"imageData"];
    self.textFieldContent = [[NSUserDefaults standardUserDefaults]objectForKey:@"textFieldContent"];
    
    
    self.imageView.image = [UIImage imageWithData:self.imageData];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.imageView addGestureRecognizer:singleTap];
    
    
    
    if (self.imageData != nil) {
        self.picSize.hidden = NO;
        self.picSize.text = [NSString stringWithFormat:@"%.2fMB",(double)[self.imageData length]/1024/1024];
    }
    self.textField.text = self.textFieldContent;
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

#pragma mark - SinaWeiboRequest Delegate
-(void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
    expectedLength = MAX([response expectedContentLength], 1);
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
    
    
}

- (void)request:(SinaWeiboRequest *)request   didSendBodyData:(NSInteger)bytesWritten
totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
   
	HUD.mode = MBProgressHUDModeDeterminate;
    currentLength += bytesWritten;
    HUD.progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
}
- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}



- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    	[HUD removeFromSuperview];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
    [HUD hide:YES];
    //恢复程序运行时自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", [[NSString alloc] initWithFormat:@"%@",self.textField.text]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", self.textField.text]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
	
    //    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
    HUD.color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];

	[HUD hide:YES afterDelay:2];
    //恢复程序运行时自动锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //    PullTableView *tableView =(id)[self.view viewWithTag:1];
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = result;
     
        NSMutableArray *temp =[NSMutableArray new];
        [temp addObject:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:[NSString stringWithFormat:@"userName"]];
        NSString * i =[userInfo objectForKey:@"profile_image_url"] ;
        NSArray * array = [i componentsSeparatedByString:@"/50/"];
        NSString *new = [NSString stringWithFormat:@"%@/180/%@",array[0],array[1]];
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:[NSString stringWithFormat:@"profile_image_url"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];///两秒后返回上一页 ~~~~~~~~~
        });
        // [self userInfoButtonPressed];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = [result objectForKey:@"statuses"];
    }
    else if ([request.url hasSuffix:@"statuses/home_timeline.json"])
    {
        NSLog(@"3");
        homeline = [result objectForKey:@"statuses"];
        
        
        //  tableviewlist =[[NSMutableArray alloc] init];
        if ([homeline count]!= 0)
        {
            //
            //            if (tableView.pullTableIsRefreshing ==YES)
            //            {
            //                tableviewlist = [[homeline arrayByAddingObjectsFromArray:tableviewlist] mutableCopy];
            //                NSLog(@" %d %@",[homeline count],[[homeline objectAtIndex:0] objectForKey:@"id"]);
            //                NSString *ValueString =[NSString stringWithFormat:@"%@",[[homeline objectAtIndex:0] objectForKey:@"id"]];
            //                since_id = ValueString;
            //            }
            //
            //            //[tableviewlist insertObjects:homeline atIndexes:0];
            //            //tableviewlist = homeline;
            //            NSLog(@"111111%lu",(unsigned long)[tableviewlist count]);
            //            if (tableView.pullTableIsLoadingMore)
            //            {
            //                NSMutableArray *temp = [homeline mutableCopy];
            //                [temp removeObjectAtIndex:0];
            //                tableviewlist = [[tableviewlist arrayByAddingObjectsFromArray:temp] mutableCopy];
            //                NSLog(@"222222%lu",(unsigned long)[tableviewlist count]);
            //
        }
        
        
        
        
        
        
        
        // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
        //   [[NSUserDefaults standardUserDefaults] synchronize];
        // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
        //  [viewData setObject:rowData forKey:@"rowData"];
        // [viewData synchronize];
        
        
    }
    else if ([request.url hasSuffix:@"comments/show.json"])
    {   //PullTableView *tableView2=(id)[self.view viewWithTag:2];
        //NSLog(@"3");
        WeiboContent = [result objectForKey:@"comments"];
        
        NSLog(@" 1111111%@",[[[homeline objectAtIndex:0] objectForKey:@"user"]  objectForKey:@"name"]);
        NSLog(@"WeiboContent%@",WeiboContent);
        
        //[tableView2 reloadData];
        
        
        // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
        //   [[NSUserDefaults standardUserDefaults] synchronize];
        // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
        //  [viewData setObject:rowData forKey:@"rowData"];
        // [viewData synchronize];
        // [tableView reloadData];
        //NSLog(@"%@",WeiboContent);
        isflage = YES;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //[alertView show];
        
        postStatusText = nil;
        [self dismissModalViewControllerAnimated:YES];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      //  [alertView show];
        
        postImageStatusText = nil;isPic = NO;
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"access token result = %@", result);
        
        // [self logInDidFinishWithAuthInfo:result];
        
    }
    // [self resetButtons];
}
static int post_status_times = 0;
- (void)postStatusButtonPressed
{
    if (!postStatusText)
    {
        post_status_times ++;
        postStatusText = nil;
        postStatusText = [[NSString alloc] initWithFormat:@"%@",self.textField.text];
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", [[NSString alloc] initWithFormat:@"%@",self.textField.text]]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    [alertView show];
}

static int post_image_status_times = 0;
- (void)postImageStatusButtonPressed
{
    if (!postImageStatusText)
    {
        post_image_status_times ++;
        postImageStatusText = nil;
        
        postImageStatusText = [[NSString alloc] initWithFormat:@"%@",self.textField.text];
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post image status with text \"%@\"", self.textField.text]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //禁止程序运行时自动锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",self.textField.text], @"status", nil]
                           httpMethod:@"POST"
                             delegate:self];
            HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            HUD.color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];

            HUD.delegate = self;
            
        }
        else if (alertView.tag == 1)
        {
            // post image status
            SinaWeibo *sinaweibo = [self sinaweibo];
            
            [sinaweibo requestWithURL:@"statuses/upload.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.textField.text, @"status",
                                       self.imageView.image, @"pic", nil]
                           httpMethod:@"POST"
                             delegate:self];
            HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            HUD.color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];

            HUD.delegate = self;
            
        }
    }
}


- (IBAction)post:(id)sender {
    
    [self.textField resignFirstResponder];

    if (isPic||self.imageData) {
        if (self.textField.text.length ==0 ) {
            self.textField.text = @"分享图片";
        }
        
        [self postImageStatusButtonPressed];
        //  isPic = NO;
    }
    else{
        
        [self postStatusButtonPressed];
    }
    
}

- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///////////////相册
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    isPic = YES;
    [imageData writeToFile:fullPath atomically:NO];
    // imagename=imageName;
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    postImage =image;
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    //imagePath =fullPath;
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    // imagePath = fullPath;
    //  isFullScreen = NO;
    imageData2 = [NSData dataWithContentsOfFile:fullPath];
    float kCompressionQuality = 1;
    NSData *photo = UIImageJPEGRepresentation(savedImage, kCompressionQuality);
    if ([photo length]> 1024*1024*2)
    {
        CGSize i = savedImage.size;
        i.height = i.height/2.5;
        i.width = i.width/2.5;
        [self.imageView setImage:[UIImage  imageWithData:photo]];
        self.imageView.image = [self scaleToSize:savedImage size:i];
        self.picSize.hidden = NO;
        
        self.picSize.text = [NSString stringWithFormat:@"已压缩到%.2fMB",(double)[UIImageJPEGRepresentation(self.imageView.image, 1.0) length]/1024/1024];
    }
    else
    {
        
        [self.imageView setImage:[UIImage  imageWithData:photo]];
        self.picSize.hidden = NO;
        
        self.picSize.text = [NSString stringWithFormat:@"%.2fMB",(double)[photo length]/1024/1024];
        self.imageView.tag = 100;
    }
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    [self.textField resignFirstResponder];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [sheet addButtonWithTitle:@"相机"];
        [sheet addButtonWithTitle:@"从相册选择"];
        
        
        // 同时添加一个取消按钮
        [sheet addButtonWithTitle:@"Cancel"];
        // UILabel *title = [[sheet subviews] objectAtIndex:2];
        //    [title setTextColor:[UIColor redColor]];
        sheet.cancelButtonIndex = sheet.numberOfButtons-1;
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}
@end
