//
//  WeiboPersonalDetailTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-13.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboPersonalDetailTableViewController.h"
#import "WeiboAllInOneTableViewCell.h"
@interface WeiboPersonalDetailTableViewController ()

@end

@implementation WeiboPersonalDetailTableViewController

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

///////////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
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
    // 2.2秒后刷新表格UI
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //  [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //  [self.tableView headerEndRefreshing];
        NSString *ValueString =[NSString stringWithFormat:@"%@",[[Commentslist objectAtIndex:0] objectForKey:@"id"]];
        since_id = ValueString;
        [self getWeiboContent];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
        //        [self.tableView reloadData];
        //
        //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //  [self.tableView footerEndRefreshing];
        NSString *ValueString =[NSString stringWithFormat:@"%@",[[Commentslist objectAtIndex:[Commentslist count]-1] objectForKey:@"id"]];
        max_id = ValueString;
        loadingMore = YES;
        [self getWeiboContentMore];
    });
}
- (void)getWeiboContent
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.title,@"screen_name",since_id,@"since_id",nil];
    Requst=[sinaweibo requestWithURL:@"statuses/user_timeline.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}
- (void)getWeiboContentMore
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.title,@"screen_name",max_id,@"max_id",nil];
    Requst=[sinaweibo requestWithURL:@"statuses/user_timeline.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
  
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setupRefresh];
    //headerView.view.frame = self.view.frame;
    self.title = self.screenName;
    UINib *nib3 =[UINib nibWithNibName:@"WeiboAllInOneTableViewCell" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"WeiboAllInOneTableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    WeiboPersonalDetailViewController *headerView = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiboPersonalDetailViewController"];
    headerView.screen_name = self.screenName;
    headerView.userInfo = userInfo;
    CGRect frame = headerView.view.frame;
    frame.size.height = 180;
    headerView.view.frame = frame;
    [self addChildViewController:headerView];
    self.tableView.tableHeaderView = headerView.view;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%@",self.screenName], @"screen_name", nil]
                       httpMethod:@"GET"
                         delegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
     return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboAllInOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboAllInOneTableViewCell" forIndexPath:indexPath];
    
    rowData = [userInfo objectForKey:@"status"];

    // Configure the cell...
    
    NSString * userImageUrl =[[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSArray * array1 = [userImageUrl componentsSeparatedByString:@"/50/"];
    NSString *new = [NSString stringWithFormat:@"%@/180/%@",array1[0],array1[1]];
    
    
    
    UITapGestureRecognizer *nameSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapName:)];
    [cell.name addGestureRecognizer:nameSingleTap];
    
    [cell.userImage setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:@"avatar_hd"]]];
    cell.name.text = self.screenName;
    
    cell.time.text =[self getTimeString:[rowData objectForKey:@"created_at"]];
    cell.content.text = [rowData objectForKey:@"text"];
    NSString *from =[rowData objectForKey:@"source"];
    if (from.length>5) {
        NSArray * array = [from componentsSeparatedByString:@"\">"];
        NSString *temp = array[1];
        
        array = [temp componentsSeparatedByString:@"<"];
        from = array[0];
        cell.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
    }
    
    if ([from isEqualToString:@"知乎Plus"]|| [from isEqualToString:@"浩然的小尾巴"]) {
        cell.from.textColor=[UIColor orangeColor];
    }else{
        cell.from.textColor=[UIColor lightGrayColor];
    }
    
    
    CGRect orgRect=cell.content.frame;
    CGSize  size = [[rowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+20;
    cell.content.frame=orgRect;
    
    
    CGRect frame = [cell.weiboImages[0] frame];
    frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+10.f;
    
    
    
    
    
    NSArray *picsArray =[rowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
    int i =0;
    
    for (UIImageView *weiboImages in cell.weiboImages) {
        
        if (i<[picsArray count]) {
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [weiboImages addGestureRecognizer:singleTap];
            
            weiboImages.tag=100+indexPath.row*10000+i;
            
            
            weiboImages.frame=frame;
            weiboImages.clipsToBounds = YES;
            weiboImages.contentMode=UIViewContentModeScaleAspectFill;
            frame.origin.x = frame.origin.x +88;
            
            if (i==2) {
                frame = [cell.weiboImages[0] frame];
                frame.origin.y = frame.origin.y+88;
                
                
            }
            if (i==5) {
                CGRect temp = [cell.weiboImages[0] frame];
                frame.origin.x =temp.origin.x;
                frame.origin.y = frame.origin.y+88;
            }
            
            
            NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
            transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
            
            NSString *fileName = [transferUrl lastPathComponent];
            if ([fileName hasSuffix:@".gif"]) {
                transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
            }
            [weiboImages setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
            i++;
            weiboImages.hidden=NO;
        }
        
        else
        {
            weiboImages.hidden=YES;
        }
    }
    
    /////////////////////////////转发内容布局、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
    
    if ([rowData objectForKey:@"retweeted_status"]!=nil) {
        
        NSDictionary *retweetRowData = [rowData objectForKey:@"retweeted_status"];
        cell.retweetView.hidden=NO;
        cell.retweetView.tag = indexPath.row;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetViewDetail:)];
        [cell.retweetView addGestureRecognizer:singleTap];
        UITapGestureRecognizer *nameSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapName:)];
        [cell.retweetName addGestureRecognizer:nameSingleTap];
        
        
        frame = cell.retweetView.frame;
        frame.origin.y =cell.content.frame.size.height + cell.content.frame.origin.y+10.f;
        cell.retweetView.frame = frame;
        
        cell.retweetName.text = [[retweetRowData objectForKey:@"user"] objectForKey:@"name"];
        cell.retweetTime.text =[self getTimeString:[retweetRowData objectForKey:@"created_at"]];
        cell.retweetContent.text=[retweetRowData objectForKey:@"text"];
        
        CGRect orgRect=cell.retweetContent.frame;
        CGSize  size = [[retweetRowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        orgRect.size.height=size.height+20;
        cell.retweetContent.frame=orgRect;
        
        size=[[[retweetRowData objectForKey:@"user"] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        frame = cell.retweetFrom.frame;
        frame.origin.x = size.width + cell.retweetName.frame.origin.x +10;
        cell.retweetFrom.frame= frame;
        
        NSString *retweetFrom =[retweetRowData objectForKey:@"source"];///////来源处理////////
        if (retweetFrom.length>5) {
            
            
            NSArray * retweetArray = [retweetFrom componentsSeparatedByString:@"\">"];
            NSString *retweetTemp = retweetArray[1];
            retweetArray = [retweetTemp componentsSeparatedByString:@"<"];
            retweetFrom = retweetArray[0];
            cell.retweetFrom.text =[NSString stringWithFormat:@"来自%@",retweetArray[0]];///////来源处理////////
            
        }
        if ([cell.from.text isEqualToString:@"来自知乎Plus"]||[cell.from.text isEqualToString:@"来自浩然的小尾巴"]) {
            cell.retweetFrom.textColor=[UIColor orangeColor];
        }else{
            cell.retweetFrom.textColor=[UIColor lightGrayColor];
        }
        
        
        
        
        CGRect frame = [cell.retweetWeiboImages[0] frame];
        frame.origin.y = cell.retweetContent.frame.size.height + cell.retweetContent.frame.origin.y+10.f;
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
        
        
        
        for (UIImageView *weiboImages in cell.retweetWeiboImages) {
            
            if (i<[retweetPicsArray count]) {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [weiboImages addGestureRecognizer:singleTap];
                
                weiboImages.tag=100+indexPath.row*10000+i;
                
                
                
                
                weiboImages.frame=frame;
                weiboImages.clipsToBounds = YES;
                weiboImages.contentMode=UIViewContentModeScaleAspectFill;
                frame.origin.x = frame.origin.x +88;
                
                if (i==2) {
                    frame = [cell.retweetWeiboImages[0] frame];
                    frame.origin.y = frame.origin.y+88;
                    
                    
                }
                if (i==5) {
                    CGRect temp = [cell.retweetWeiboImages[0] frame];
                    frame.origin.x =temp.origin.x;
                    frame.origin.y = frame.origin.y+88;
                }
                
                
                NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
                NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
                transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
                NSString *fileName = [transferUrl lastPathComponent];
                if ([fileName hasSuffix:@".gif"]) {
                    transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
                }
                [weiboImages setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                i++;
                weiboImages.hidden=NO;
            }
            
            else
            {
                weiboImages.hidden=YES;
            }
        }
        
        
        frame =cell.retweetView.frame;
        
        if ([retweetPicsArray count] != 0) {
            
            int height = 0;
            cell.retweetView.hidden=NO;
            //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
            if ([retweetPicsArray count]>6) {
                
                height = 88;
                //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            if ([retweetPicsArray count]>3) {
                height = height +88;
                // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            
            CGRect temp = [cell.retweetWeiboImages[0] frame];
            
            frame.size.height = temp.size.height + temp.origin.y+20.f+height;
            
            
            cell.retweetView.frame= frame;
            
        }
        else{   /////////////转发的微博不带图片retweetView 的布局
            frame.size.height = cell.retweetContent.frame.size.height + cell.retweetContent.frame.origin.y+20.f;
            
            
            cell.retweetView.frame= frame;
            
        }
        
        // frame =cell.gap.frame;
        // frame.origin.y = cell.retweetView.frame.origin.y+cell.retweetView.frame.size.height;
        // cell.gap.frame=frame;
    }
    
    
    
    
    frame = cell.content.frame;
    if ([NSURL URLWithString: [rowData objectForKey:@"bmiddle_pic"]]==nil) {
        
        frame.size.height = cell.content.frame.size.height + cell.content.frame.origin.y+20.f+30;
        cell.contentView.frame= frame;
        
        frame = cell.retweetButton.frame;
        frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.retweetButton.frame = frame;
        
        frame = cell.reviewButton.frame;
        frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.reviewButton.frame = frame;
        
        frame = cell.zhanButton.frame;
        frame.origin.y =  cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.zhanButton.frame = frame;
        
        if ([rowData objectForKey:@"retweeted_status"]!=nil) {
            frame.size.height =cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y+0.f+30;
            cell.contentView.frame= frame;
            
            frame = cell.retweetButton.frame;
            frame.origin.y = cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.retweetButton.frame = frame;
            
            frame = cell.reviewButton.frame;
            frame.origin.y = cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.reviewButton.frame = frame;
            
            frame = cell.zhanButton.frame;
            frame.origin.y =  cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.zhanButton.frame = frame;
            
            cell.retweetView.hidden=NO;
        }else{
            cell.retweetView.hidden=YES;
        }
        
    }else{
        
        int height = 0;
        cell.retweetView.hidden=YES;
        //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
        if ([picsArray count]>6) {
            
            height = 88;
            //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        if ([picsArray count]>3) {
            height = height +88;
            // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        
        
        CGRect temp = [cell.weiboImages[0] frame];
        frame.size.height = temp.size.height + temp.origin.y+20.f+height+30;
        
        frame = cell.retweetButton.frame;
        frame.origin.y =  temp.size.height + temp.origin.y+20.f+height;
        cell.retweetButton.frame = frame;
        
        frame = cell.reviewButton.frame;
        frame.origin.y = temp.size.height + temp.origin.y+20.f+height;
        cell.reviewButton.frame = frame;
        
        frame = cell.zhanButton.frame;
        frame.origin.y =  temp.size.height + temp.origin.y+20.f+height;
        cell.zhanButton.frame = frame;
        cell.contentView.frame= frame;
        
        
    }
    cell.retweetButton.hidden = YES;///////隐藏多余按钮
    cell.reviewButton.hidden = YES;
    cell.zhanButton.hidden =YES;
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    //   WeiboTableViewCell *cell = (WeiboTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    //    NSString *content = [tableviewlist[indexPath.row]  objectForKey:@"text"];
    //    // 計算出顯示完內容需要的最小尺寸
    //      CGSize  size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    //
    //
    //    if ([tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
    //         return size.height+100+100;
    //    }
    //
    //    return size.height+140;
    //    //cell.content.frame.size.height+cell.userImage.frame.size.height;
    //
    WeiboDetailViewController *view=[WeiboDetailViewController new];
    rowData = [userInfo objectForKey:@"status"];

    view.rowData =rowData;
    
    return view.view.frame.size.height+0;
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
//        NSString * i =[userInfo objectForKey:@"profile_image_url"] ;
//        NSArray * array = [i componentsSeparatedByString:@"/50/"];
//        NSString *new = [NSString stringWithFormat:@"%@/180/%@",array[0],array[1]];
        //   [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:[NSString stringWithFormat:@"profile_image_url"]];
        
        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //   [self.navigationController popViewControllerAnimated:YES];///两秒后返回上一页 ~~~~~~~~~
        });
        // [self userInfoButtonPressed];
        WeiboPersonalDetailViewController *headerView = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiboPersonalDetailViewController"];
        headerView.screen_name = self.screenName;
        headerView.userInfo = userInfo;
        CGRect frame = headerView.view.frame;
        frame.size.height = 180;
        headerView.view.frame = frame;
        [self addChildViewController:headerView];
        self.tableView.tableHeaderView = headerView.view;
        
        [self.tableView reloadData];
        
        
       
        
        

        
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = [result objectForKey:@"statuses"];
        
        
        {
            NSLog(@"3");
            homeline = [result objectForKey:@"statuses"];
            
            
            //  tableviewlist =[[NSMutableArray alloc] init];
            if ([homeline count]!= 0)
            {
                if (loadingMore)
                {
                    NSMutableArray *temp = [homeline mutableCopy];
                    [temp removeObjectAtIndex:0];
                    tableviewlist = [[tableviewlist arrayByAddingObjectsFromArray:temp] mutableCopy];
                    NSLog(@"222222%lu",(unsigned long)[tableviewlist count]);
                    loadingMore = NO;
                }
                else{
                    
                    
                    tableviewlist = [[homeline arrayByAddingObjectsFromArray:tableviewlist] mutableCopy];
                    NSLog(@" %d %@",[homeline count],[[homeline objectAtIndex:0] objectForKey:@"id"]);
                    NSString *ValueString =[NSString stringWithFormat:@"%@",[[homeline objectAtIndex:0] objectForKey:@"id"]];
                    since_id = ValueString;
                 //   [self getUnreadCountButtonPressed];////获取角标、、、、、、、、
                }
            }
            
            
            
            
            
            
            
            // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
            //   [[NSUserDefaults standardUserDefaults] synchronize];
            // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
            //  [viewData setObject:rowData forKey:@"rowData"];
            // [viewData synchronize];
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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

- (NSString *) getTimeString : (NSString *) string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    //NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDate *creatDate = [inputFormatter dateFromString:string];
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    //时间格式
    fmt=inputFormatter;
    if (creatDate.isThisYear) {//今年
        if (creatDate.isToday) {
            //获得微博发布的时间与当前时间的差距
            NSDateComponents *cmps=[creatDate deltaWithNow];
            if (cmps.hour>=1) {//至少是一个小时之前发布的
                return [NSString stringWithFormat:@"%d小时前",cmps.hour];
            }else if(cmps.minute>=1){//1~59分钟之前发布的
                return [NSString stringWithFormat:@"%d分钟前",cmps.minute];
            }else{//1分钟内发布的
                return @"刚刚";
            }
        }else if(creatDate.isYesterday){//昨天发的
            fmt.dateFormat=@"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        }else{//至少是前天发布的
            fmt.dateFormat=@"MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    }else           //  往年
    {
        fmt.dateFormat=@"yyyy-MM-dd";
        return [fmt stringFromDate:creatDate];
    }
    //
    //    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //    [outputFormatter setLocale:[NSLocale currentLocale]];
    //    [outputFormatter setDateFormat:@"HH:mm:ss"];
    //    NSString *str = [outputFormatter stringFromDate:inputDate];
    //
    //
    //    return str;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)[tap view];
    int tagvalue = abs(view.tag);
    int row = tagvalue/10000;
    int i = tagvalue - 10000*row-100;
    
    NSDictionary *rowData1 = rowData;
    
    NSString *url=[NSString new];
    
    
    if ([[rowData1 objectForKey:@"pic_urls"] count]!=0) {
        NSArray *picsArray =[rowData1 objectForKey:@"pic_urls"];
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        //url = [self.rowData objectForKey:@"original_pic"];
        url=transferUrl;
        
        
        int count = picsArray.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray new];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            
            NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
            //url = [self.rowData objectForKey:@"original_pic"];
            url=transferUrl;
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView = (UIImageView *)[self.view viewWithTag:row*10000+i+100];// 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        
        browser.photos = photos; // 设置所有的图片
        [browser show];
        
        
        
        
    }else{
        NSDictionary *retweetRowData = [rowData1 objectForKey:@"retweeted_status"];
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];
        
        
        NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        
        url=transferUrl;
        
        int count = retweetPicsArray.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
            //url = [self.rowData objectForKey:@"original_pic"];
            url=transferUrl;
            
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView =  (UIImageView *)[self.view viewWithTag:row*10000+i+100];  // 来源于哪个UIImageView
            [photos addObject:photo];
            
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
        
        
        
        
    }
}


@end
