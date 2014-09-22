//
//  WeiboDetailAndCommentTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//
#import "WeiboDetailViewController.h"
#import "WeiboDetailAndCommentTableViewController.h"
#import "WeiboCommentTableViewCell.h"
#import "ScrollViewDetailViewController.h"
#import "WeiboReviewViewController.h"
@interface WeiboDetailAndCommentTableViewController ()

@end

@implementation WeiboDetailAndCommentTableViewController

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing)
												 name:@"headerRereshing" object:nil];
    self.tableView = (id)[self.view viewWithTag:1];
    self.tableView.contentInset =UIEdgeInsetsMake(0, 0, 44, 0);
    UINib *nib = [UINib nibWithNibName:@"WeiboCommentTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"WeiboCommentCell"];
    
    [self setupRefresh];
    [self getWeiboContent];
    
    WeiboDetailViewController *weiboDetailViewController = [WeiboDetailViewController new];
    segmentView = [CCAVSegmentController new];
    loadingMore = NO;
    segmentView.delegate=self;
//    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yourHandlingCode:)];
//    [weiboDetailViewController.weiboImage addGestureRecognizer:singleTap];
   // [weiboDetailViewController.userImage setImageWithURL:[NSURL URLWithString:self.weiboUserUrl]];
    weiboDetailViewController.rowData =self.rowData;
    self.tableView.tableHeaderView = weiboDetailViewController.view;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self addChildViewController:weiboDetailViewController];
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
    return [Commentslist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCommentCell" forIndexPath:indexPath];
     NSDictionary *rowData = Commentslist[indexPath.row];
    
    NSString *desContent =[rowData objectForKey:@"text"];
    CGRect orgRect=cell.comment.frame;
    CGSize  size = [desContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+20;
    cell.comment.frame=orgRect;
    cell.comment.text=desContent;
    cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
    NSString *userurl= [[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];
    [cell.userImage setImageWithURL:[NSURL URLWithString:userurl]];
    cell.time.text=  [rowData objectForKey:@"created_at"];
    // Configure the cell...
    
    
    NSString *from =[rowData objectForKey:@"source"];
    NSArray * array = [from componentsSeparatedByString:@"\">"];
    
    NSString *temp = array[1];
    array = [temp componentsSeparatedByString:@"<"];
    from = array[0];
    cell.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
    if ([from isEqualToString:@"知乎Plus"]) {
        cell.from.textColor=[UIColor orangeColor];
    }else{
        cell.from.textColor=[UIColor lightGrayColor];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowData1 = Commentslist[indexPath.row];
    NSString *content = [Commentslist[indexPath.row]  objectForKey:@"text"];
    // 計算出顯示完內容需要的最小尺寸
    CGSize  size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    

    return size.height+120;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (section==0) {
        //NewsDateViewController *newView= [NewsDateViewController new];
        //    segmentView.date=[NSDate date];
        
        
        return segmentView.view;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WeiboReviewViewController *huifu=[self.storyboard instantiateViewControllerWithIdentifier:@"WeiboReviewViewController"];
        huifu.weiboid =self.WeiboId;
        int i =indexPath.row;
        NSDictionary *rowData = Commentslist[i];
        
        huifu.weibousername= [[rowData objectForKey:@"user"] objectForKey:@"name"];
        [self.navigationController pushViewController:huifu animated:YES];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
        return segmentView.view.frame.size.height;
   
}
-(void)segmentControllDidClicked:(UIButton *)sender
{
    
    
    NSString *message=[NSString stringWithFormat:@"通过delegate点击了%@的按钮",sender.titleLabel.text];
    UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [myAlertView show];
    
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



- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
- (void)getWeiboContent
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.WeiboId,@"id",since_id,@"since_id",nil];
    Requst=[sinaweibo requestWithURL:@"comments/show.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    UITableView *tableView2=(id)[self.view viewWithTag:2];
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}- (void)getWeiboContentMore
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.WeiboId,@"id",max_id,@"max_id",nil];
    Requst=[sinaweibo requestWithURL:@"comments/show.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    UITableView *tableView2=(id)[self.view viewWithTag:2];
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"comments/show.json"])
    {
        //self.weiboComments;
        //NSLog(@"3");
        self.weiboComments = [result objectForKey:@"comments"];
        
        
        
        if ([self.weiboComments count]!= 0)
        {
            
            if (loadingMore)
            {
                NSMutableArray *temp = [self.weiboComments mutableCopy];
                [temp removeObjectAtIndex:0];
                Commentslist = [[Commentslist arrayByAddingObjectsFromArray:temp] mutableCopy];
                loadingMore = NO;
                
            }else{
                
                Commentslist = [[self.weiboComments arrayByAddingObjectsFromArray:Commentslist] mutableCopy];
                
                
                
            }
            
            //[tableviewlist insertObjects:homeline atIndexes:0];
            //tableviewlist = homeline;
            NSLog(@"111111%lu",(unsigned long)[Commentslist count]);
            
            if ([Commentslist count ]== 0) {
                Commentslist = [[self.weiboComments arrayByAddingObjectsFromArray:Commentslist] mutableCopy];
            }
            
            
            //NSLog(@" 1111111%@",[[[homeline objectAtIndex:1] objectForKey:@"user"]  objectForKey:@"name"]);
     //       NSLog(@"WeiboContent%@",Commentslist);
            
            
            
            
            // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
            //   [[NSUserDefaults standardUserDefaults] synchronize];
            // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
            //  [viewData setObject:rowData forKey:@"rowData"];
            // [viewData synchronize];
            // [tableView reloadData];
            //NSLog(@"%@",WeiboContent);
        }
        
           }
    [self.tableView reloadData];
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];

}

-(void)yourHandlingCode:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView *)[gestureRecognizer view];
//    int tagvalue = view.tag;
//    int section = tagvalue/10000;
//    int row = tagvalue- section*10000;
    NSString *url=[self.rowData objectForKey:@"original_pic"];
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",url]];
    //  webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)review:(id)sender {
    
    WeiboReviewViewController *huifu=[self.storyboard instantiateViewControllerWithIdentifier:@"WeiboReviewViewController"];

    huifu.weiboid =  self.WeiboId;
    [self.navigationController pushViewController:huifu animated:YES];
    
}
@end
