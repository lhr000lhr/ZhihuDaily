//
//  TextAndPicturesTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "TextAndPicturesTableViewController.h"
#import "CCTVHotTVTableViewCell.h"
#import "generalThreadTableViewCell.h"
#import "CCTVDetailTableViewController.h"
#import "CCTVGeneralThreadTableViewController.h"
#import "NYSegmentedControl.h"

@interface TextAndPicturesTableViewController ()

@end

@implementation TextAndPicturesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title =@"微视";
   
    [self setupRefresh];
//    [self downLoadTvCircleData];
    
    UINib *nib = [UINib nibWithNibName:@"generalThreadTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"generalThreadTableViewCell"];

    
    scroller=[[JScrollView_PageControl_AutoScroll alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
    scroller.autoScrollDelayTime=3.0;
    scroller.delegate=self;
//    [scroller setViewsArray:[NSMutableArray new]];
    [scroller shouldAutoShow:YES];
    self.tableView.tableHeaderView= scroller;
    
    listItems = [NSArray new];
//    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)downLoadTvCircleData
{
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://58.68.243.109/cctvapi/tv/home"
                                                       httpMethod:@"POST"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
    
//    api 服务器
//    192.168.1.35
//    58.68.243.109
//    58.68.243.110

    
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    receivedData = result;
    listItems = [result objectForKey:@"items"];
    
    NSLog(@"%@",result[@"error"]);
    
    
    /////////scrollView 图片处理
    NSMutableArray *banner = [receivedData objectForKey:@"banner"];
    hot_activity = [receivedData objectForKey:@"hot_tv"];
    hot_thread = [receivedData objectForKey:@"hot_thread"];
    NSMutableArray *bannerPics = [NSMutableArray new];
    for (NSDictionary *eachBanner in banner)
    {
        
        UIImageView *temp=[UIImageView new];
        
        NSString *url = [eachBanner objectForKey:@"pic"];
        
        [temp setImageURLStr:url
                 placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
        
        [bannerPics addObject:temp];
        
        
    }
    scroller=[[JScrollView_PageControl_AutoScroll alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
    scroller.autoScrollDelayTime=3.0;
    scroller.delegate=self;
    [scroller setViewsArray:bannerPics];
    [scroller shouldAutoShow:YES];
    self.tableView.tableHeaderView= scroller;
    
    
    
    
    
    
    
    [self.tableView reloadData];
    
    [self.tableView headerEndRefreshing];

    
}
#pragma mark -  scrollView委托
- (void)didClickPage:(JScrollView_PageControl_AutoScroll *)view atIndex:(NSInteger)index
{
    
    
     NSLog(@"点击了%ld",(long)index);

    
    
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
    [self downLoadTvCircleData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //  [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        //[self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    //    // 1.添加假数据
    //   // for (int i = 0; i<5; i++) {
    //  //      [self.fakeData addObject:MJRandomData];
    // //   }
    //
    
    //
    //    // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格

            
    //       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.tableView footerEndRefreshing];
        });
}


#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (section==0) {
        //NewsDateViewController *newView= [NewsDateViewController new];
        //    segmentView.date=[NSDate date];
        
        
        
        //return segmentView.view;
//        NewsDateViewController *newView= [NewsDateViewController new];
//        newView.date=[NSDate date];
        
        return [UIView new];
        
    }else{
        //  return segmentView.view;
     
        self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Light", @"Dark"]];
        [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
        self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
        self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
        self.segmentedControl.borderWidth = 1.0f;
        self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
        self.segmentedControl.drawsGradientBackground = YES;
        self.segmentedControl.segmentIndicatorInset = 2.0f;
        self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
        self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
        self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
        self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl sizeToFit];
        
        
        UIView *lightControlExampleView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                    0.0f,
                                                                                                    CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                                                    44.0f)];
        foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor colorWithRed:0.36f green:0.64f blue:0.88f alpha:1.0f];
        NYSegmentedControl *foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Nearby", @"Worldwide"]];
        foursquareSegmentedControl.titleTextColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
        foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
        foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
        foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
        foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:1.0f];
        foursquareSegmentedControl.borderWidth = 0.0f;
        foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
        foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
        foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
        [foursquareSegmentedControl sizeToFit];
        foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
        foursquareSegmentedControl.center = CGPointMake(lightControlExampleView.center.x, lightControlExampleView.center.y + 30.0f);
        foursquareSegmentedControlBackgroundView.center = foursquareSegmentedControl.center;
        
        return foursquareSegmentedControl;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
            return 0;
    }else
    {
    return  0;
    //segmentView.view.frame.size.height;
       }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //some functions
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
  //  CCTVHotTVTableViewCell *cell =  (CCTVHotTVTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CCTVHotTVTableViewCell"];
    if (indexPath.section ==0)
    {
        
    
       CCTVHotTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCTVHotTVTableViewCell"
                                                                forIndexPath:indexPath];
    NSDictionary *rowData = hot_activity[indexPath.row];
//    cell.textLabel.text =[rowData objectForKey:@"name"];
//    [cell.imageView setImageURLStr:[rowData objectForKey:@"thumbpic"]
//                       placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
    cell.hot_tvName.text = [rowData objectForKey:@"name"];
    cell.hot_tvDesc.text = [rowData objectForKey:@"desc"];
    [cell.hot_tvPic setImageURLStr:[rowData objectForKey:@"pic"]
                       placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentHotCell" forIndexPath:indexPath];
        NSDictionary *rowData = hot_thread[indexPath.row];
        // Configure the cell...
        cell.textLabel.text = [rowData objectForKey:@"name"];
        cell.detailTextLabel.text = [rowData objectForKey:@"reply_time"];
        
        
        return cell;
        
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (section ==0) {
        return hot_activity.count;
    }
    else
    {
        return hot_thread.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {

        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *rowData = hot_activity[selectedIndexPath.row];

        CCTVDetailTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.title = [rowData objectForKey:@"name"];
        detailViewController.rowData = rowData;

    }
    if ([[segue identifier] isEqualToString:@"MainToThread"])
    {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *rowData = hot_thread[selectedIndexPath.row];
        CCTVGeneralThreadTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.rowData = rowData;
        
    }
    
}


@end
