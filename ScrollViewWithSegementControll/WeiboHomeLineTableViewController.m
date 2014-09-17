//
//  WeiboHomeLineTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-17.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboHomeLineTableViewController.h"

@interface WeiboHomeLineTableViewController ()

@end

@implementation WeiboHomeLineTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    UINib *nib = [UINib nibWithNibName:@"WeiboTableViewCell" bundle:nil];
   
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
    UINib *nib2 =[UINib nibWithNibName:@"WeiboWithoutImageTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"WeiboWithoutImageCell"];

  
     since_id = nil;
    self.title=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    
    [self setupRefresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [tableviewlist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
       rowData = tableviewlist[indexPath.row];
 
//    CGRect orgRect=cell.content.frame;
//
    if ( [tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
        
     
        NSString *desContent =[rowData objectForKey:@"text"];
    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
//    CGSize  size = [desContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
//    orgRect.size.height=size.height+20;
//    cell.content.frame=orgRect;
//
    
//    CGSize size = CGSizeMake(320,2000);
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelsize = [desContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    //[cell.content setFrame:CGRectMake:(0,0, labelsize.width, labelsize.height)];
//    orgRect.size.height=size.height+20;
//    cell.content.frame=orgRect;
  
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
   
 
    
    
    cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
    cell.time.text =  [rowData objectForKey:@"created_at"];
    cell.content.text = desContent;
    
    if ( [tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
        [cell.weiboImage setImageWithURL: [NSURL URLWithString: [rowData objectForKey:@"bmiddle_pic"]]];
        cell.weiboImage.hidden = NO;
    }else{
        CGRect orgRect=cell.weiboImage.frame;
        
        orgRect.size.height =0;
        orgRect.origin.y = cell.contentView.frame.size.height-5;
        cell.weiboImage.frame= orgRect;
       // cell.weiboImage.hidden = YES;
    }
           
    
    
    NSString *userurl= [[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];////设置cell中的头像

    [cell.userImage setImageWithURL:[NSURL URLWithString:userurl]
                   placeholderImage:[UIImage imageNamed:@"Expression_2"]];
    
    
    
    
    
    
    
    
    if ( [rowData objectForKey:@"retweeted_status"]!= nil) {  /////显示转发微博
        
    }
    return cell;
        
        
    }
    else{
        
        
           WeiboWithoutImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboWithoutImageCell" forIndexPath:indexPath];
        
        
        cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
        cell.time.text =  [rowData objectForKey:@"created_at"];
         NSString *desContent =[rowData objectForKey:@"text"];
        cell.content.text = desContent;
        NSString *userurl= [[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];////设置cell中的头像
        [cell.userImage setImageWithURL:[NSURL URLWithString:userurl]
                       placeholderImage:[UIImage imageNamed:@"Expression_2"]];
        

        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
 //   WeiboTableViewCell *cell = (WeiboTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *rowData1 = tableviewlist[indexPath.row];
    NSString *content = [tableviewlist[indexPath.row]  objectForKey:@"text"];
    // 計算出顯示完內容需要的最小尺寸
      CGSize  size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
   
    if ([tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
         return size.height+100+100;
    }
    
    return size.height+100;
    //cell.content.frame.size.height+cell.userImage.frame.size.height;
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///////////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新,不客气_(:з」∠)_";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @" - ( ゜- ゜)つロ 乾杯~ ";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    //   for (int i = 0; i<5; i++) {
    //       [self.fakeData insertObject:MJRandomData atIndex:0];
    //  }
  //  [self getData];
    // 2.2秒后刷新表格UI
    [self homelineButtonPressed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
       // [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
      //  [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    //    // 1.添加假数据
    //   // for (int i = 0; i<5; i++) {
    //  //      [self.fakeData addObject:MJRandomData];
    // //   }
    //
   // [self getOneDayData];
    //
    //    // 2.2秒后刷新表格UI
   // [self homelineButtonPressed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        // 刷新表格
    //        [self.tableView reloadData];
    //
    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
          [self.tableView footerEndRefreshing];
    });
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
               NSMutableArray *temp =[NSMutableArray new];
        [temp addObject:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:[NSString stringWithFormat:@"userName"]];
        NSString * i =[userInfo objectForKey:@"profile_image_url"] ;
        NSArray * array = [i componentsSeparatedByString:@"/50/"];
        NSString *new = [NSString stringWithFormat:@"%@/180/%@",array[0],array[1]];
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:[NSString stringWithFormat:@"profile_image_url"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
       
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
            
            tableviewlist = [[homeline arrayByAddingObjectsFromArray:tableviewlist] mutableCopy];
            NSLog(@" %d %@",[homeline count],[[homeline objectAtIndex:0] objectForKey:@"id"]);
            NSString *ValueString =[NSString stringWithFormat:@"%@",[[homeline objectAtIndex:0] objectForKey:@"id"]];
            since_id = ValueString;
        
        
        }
        
        
        
        
        
        
        
        // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
        //   [[NSUserDefaults standardUserDefaults] synchronize];
        // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
        //  [viewData setObject:rowData forKey:@"rowData"];
        // [viewData synchronize];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
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
