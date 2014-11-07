//
//  WeiboPersonalDetailViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-13.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboPersonalDetailViewController.h"
#import "OneViewController.h"

@interface WeiboPersonalDetailViewController ()

@end

@implementation WeiboPersonalDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.screen_name;
    self.userName.text = self.screen_name;
    
    
    
    
    self.followers.text = [NSString stringWithFormat:@"粉丝:%@",[self.userInfo valueForKey:@"followers_count"]];
    self.friends.text   = [NSString stringWithFormat:@"关注:%@",[self.userInfo valueForKey:@"friends_count"]];
    self.statuses.text  = [NSString stringWithFormat:@"微博:%@",[self.userInfo valueForKey:@"statuses_count"]];
    [self.userImage setImageWithURL:[NSURL URLWithString:[self.userInfo valueForKey:@"avatar_hd"]]];
    if ([[self.userInfo valueForKey:@"remark"] length]>1)
    {
        self.userName.text  = [NSString stringWithFormat:@"%@(%@)",[self.userInfo valueForKey:@"screen_name"],[self.userInfo valueForKey:@"remark"]];
    }
//    [sinaweibo requestWithURL:@"users/show.json"
//                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",self.userName.text], @"screen_name", nil]
//                   httpMethod:@"GET"
//                     delegate:self];
//    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    HUD.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [HUD removeFromSuperview];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:1];

    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = result;
        
        NSMutableArray *temp =[NSMutableArray new];
        [temp addObject:userInfo];
        
       // [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:[NSString stringWithFormat:@"userName"]];
        NSString * i =[userInfo objectForKey:@"profile_image_url"] ;
        NSArray * array = [i componentsSeparatedByString:@"/50/"];
        NSString *new = [NSString stringWithFormat:@"%@/180/%@",array[0],array[1]];
     //   [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:[NSString stringWithFormat:@"profile_image_url"]];
        
     //   [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
         //   [self.navigationController popViewControllerAnimated:YES];///两秒后返回上一页 ~~~~~~~~~
        });
        // [self userInfoButtonPressed];
        
        self.followers.text = [NSString stringWithFormat:@"粉丝:%@",[userInfo valueForKey:@"followers_count"]];
        self.friends.text   = [NSString stringWithFormat:@"关注:%@",[userInfo valueForKey:@"friends_count"]];
        self.statuses.text  = [NSString stringWithFormat:@"微博:%@",[userInfo valueForKey:@"statuses_count"]];
        [self.userImage setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:@"avatar_hd"]]];
        if ([[userInfo valueForKey:@"remark"] length]>1) {
           self.userName.text  = [NSString stringWithFormat:@"%@(%@)",[userInfo valueForKey:@"screen_name"],[userInfo valueForKey:@"remark"]];
        }
       
        
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
     //   [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //  [alertView show];
        
        postImageStatusText = nil;isPic = NO;
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"access token result = %@", result);
        
        // [self logInDidFinishWithAuthInfo:result];
        
    }
    // [self resetButtons];
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

@end
