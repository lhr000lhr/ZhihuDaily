//
//  WeiboViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-16.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboViewController.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserName:)
												 name:@"getUserName" object:nil];
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    if(!sinaWeibo.isAuthValid)
    {
        [self loginButtonPressed];
        [self homelineButtonPressed];
    }
    else{
        
       [self sinaweiboDidLogIn:sinaWeibo];
        [self userInfoButtonPressed];
    }
    // Do any additional setup after loading the view.
}
-(void)getUserName:(NSNotification*)notify
{
   // NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    [self userInfoButtonPressed];
   // self.userName.text =temp;
    
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

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginButtonPressed
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    
    userInfo = nil;
    statuses = nil;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
    
}

- (void)logoutButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    tableviewlist = nil;

    [sinaweibo logOut];
}
- (void)userInfoButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
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
#pragma mark - UIWebView Delegate


- (void)authorizeView:(SinaWeiboAuthorizeView *)authView
didRecieveAuthorizationCode:(NSString *)code
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
  //  [self resetButtons];
    [self storeAuthData];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
   // [self resetButtons];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
  //  [self resetButtons];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
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
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
//    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
   
//    PullTableView *tableView =(id)[self.view viewWithTag:1];
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = result;
        self.userName.text = [userInfo objectForKey:@"screen_name"];
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
        [alertView show];
        
        postStatusText = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        postImageStatusText = nil;isPic = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
   else
    {
        NSLog(@"access token result = %@", result);
        
        // [self logInDidFinishWithAuthInfo:result];
        
    }
    
   // [self resetButtons];
}


#pragma mark - SinaWeibo各种请求

- (void)homelineButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:since_id,@"since_id",nil];
    Requst=[sinaweibo requestWithURL:@"statuses/home_timeline.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    for (NSString *show in param) {
        NSLog(@"显示%@",show);
    }
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}
- (void)getWeiboContent
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    Requst=[sinaweibo requestWithURL:@"comments/show.json"
                              params:[NSMutableDictionary dictionaryWithObject:WeiboId forKey:@"id"]
                          httpMethod:@"GET"
                            delegate:self];
    
    
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}static int post_status_times = 0;
- (void)postStatusButtonPressed
{
    if (!postStatusText)
    {
        post_status_times ++;
        postStatusText = nil;
  //      postStatusText = [[NSString alloc] initWithFormat:@"%@",self.testField.text];
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
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
        
      //  postImageStatusText = [[NSString alloc] initWithFormat:@"%@",self.testField.text];
  
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post image status with text \"%@\"", postImageStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:postStatusText, @"status", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
        else if (alertView.tag == 1)
        {
//            // post image status
//            SinaWeibo *sinaweibo = [self sinaweibo];
//            
//            [sinaweibo requestWithURL:@"statuses/upload.json"
//                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       postImageStatusText, @"status",
//                                       self.imageView.image, @"pic", nil]
//                           httpMethod:@"POST"
//                             delegate:self];
            
        }
    }
}


@end
