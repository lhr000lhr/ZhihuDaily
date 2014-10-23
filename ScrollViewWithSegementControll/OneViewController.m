//
//  OneViewController.m
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController
static NSString *CellIdentifier = @"Cell";
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)reloadData{
    NSDictionary *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"];
    favorites =[NSMutableDictionary dictionaryWithDictionary:temp];
    
    storeFavorites = [NSMutableArray new];
    for (NSString *key in favorites) {
        NSLog(@"%@ - %@", key, favorites[key]);
        [storeFavorites addObject:favorites[key]];
    }
    temp = [NSDictionary new];
    temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
    history =[NSMutableDictionary dictionaryWithDictionary:temp];
    
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"historyArray"];
    historyArray = [NSMutableArray arrayWithArray:tempArray];
    tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"favoritesArray"];
    favoritesArray = [NSMutableArray arrayWithArray:tempArray];
    
    storeHistory = [NSMutableArray new];
    for (NSString *key in storeHistory) {
         NSLog(@"%@ - %@", key, history[key]);
        [storeHistory addObject:history[key]];
    }
    
    [self.tableView reloadData];
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  SinaWeibo *sinaWeibo =[self sinaweibo];
    
    
    ////////////加载设置
    picState = [[NSUserDefaults standardUserDefaults]boolForKey:@"picState"];
    
    
    
    ////////////////加载 收藏 和浏览历史
    NSDictionary *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"];
    favorites =[NSMutableDictionary dictionaryWithDictionary:temp];
    
    temp= [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
    history = [NSMutableDictionary dictionaryWithDictionary:temp];
    
    temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"storeNewsByDate"];
    storeNewsByDate =[NSMutableDictionary dictionaryWithDictionary:temp];
    
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"historyArray"];
    historyArray = [NSMutableArray arrayWithArray:tempArray];
    
    tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"favoritesArray"];
    favoritesArray = [NSMutableArray arrayWithArray:tempArray];
    
    ///////////////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData)
												 name:@"reloadData" object:nil];
    
    loadDayFlag = 0;
    _storeNewsArray=[NSMutableDictionary new];
  //  favorites =[NSMutableDictionary new];
   // favorites = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"];
  //  self.tableView.contentInset =UIEdgeInsetsMake(0, 0, 49, 0);
    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    [self setupRefresh];
    [self getData];
    
    
    
    
    segmentView = [[CCAVSegmentController alloc]init];
    newsDate = [NewsDateViewController new];
    segmentView.delegate=self;
    
    
    
    NSMutableArray *indexImages=nil;
    for (int i = 0; i<[self.news count]; i++)
    {
            NSDictionary *rowData = self.news[i];
        NSArray *imageurl =[rowData objectForKey:@"images"];
        NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
        if (url) {
            // [cell creatThread:url];
                     [indexImages addObject:url];
        }
    }
    
    
    
    
//    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 175)
//                                                          ImageArray:
//                             [NSArray arrayWithObjects:@"Expression_1@2x.png",@"Expression_2@2x.png",@"Expression_3@2x.png", nil]
//                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33", nil]];
//    scroller.delegate=self;
//    self.tableView.tableHeaderView= scroller;
    
    // Uncomment the followin/Users/mini1/Desktop/test/ScrollViewWithSegementControll/design/star-rate-s@2x.pngg line to preserve selection between presentations.
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
    return [_storeNewsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    NSArray *tempNews =  [[_storeNewsArray objectForKey:[NSString stringWithFormat:@"%i",section]] objectForKey:@"stories"];
    int i = [tempNews count];
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
  /*  if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  */ // cell.textLabel.text = @"111";
    NSArray *tempNews =  [[_storeNewsArray objectForKey:[NSString stringWithFormat:@"%i",indexPath.section]] objectForKey:@"stories"];
    NSDictionary *rowData =tempNews[indexPath.row];
    //self.news[indexPath.row];
    //cell.Name.text=[rowData objectForKey:@"title"] ;
    cell.major.text=[rowData objectForKey:@"title"] ;
    cell.DoctorImage.image = [UIImage imageNamed:@"Expression_1"];
    NSArray *imageurl =[rowData objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    if (url) {
       // [cell creatThread:url];
        
        if (!picState) { ////////无图模式是否开启
            [cell.DoctorImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
        }else
        {
            [cell.DoctorImage setImage:[UIImage imageNamed:@"timeline_image_loading"]];
        }
        
        
        
        //NSLog(@"%@",NSHomeDirectory());
    }
    
    cell.stars.tag=indexPath.section*10000+indexPath.row;///// 设置 star的tag

    [cell.stars addTarget:self action:@selector(addStars:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (tableView.contentOffset.y + (tableView.frame.size.height) >=tableView.contentSize.height-180){
//        [self footerRereshing];
//       // [self getOneDayData];
//        NSLog(@"调用加载更多");
//   }
    

    if ([favorites objectForKey:url]) {//////////设置收藏星星显示
        [cell.stars setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
//        [cell.major setTextColor: [UIColor blueColor]];
        [cell.major setTextColor:[UIColor colorWithRed:0.55 green:0.76 blue:0.98 alpha:1]];

    }else
    {
         [cell.stars setImage:[UIImage imageNamed:@"star-s"]forState:UIControlStateNormal];
       
       // [cell.major setTextColor:[UIColor blackColor]];
        
        if ([history objectForKey:url]) {//////////已浏览的灰色显示
            [cell.major setTextColor:[UIColor lightGrayColor]];
        }else
        {
            [cell.major setTextColor:[UIColor blackColor]];
        }
        

    }
    
    
    
    return cell;
}
-(void)addStars :(UIButton *)sender
{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    int section = sender.tag/10000;
    int row = sender.tag- section*10000;
    NSArray *tempNews =  [[_storeNewsArray objectForKey:[NSString stringWithFormat:@"%i",section]] objectForKey:@"stories"];
    NSDictionary *rowData =tempNews[row];
    NSArray *imageurl =[rowData objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    
    if (sender.imageView.image ==[UIImage imageNamed:@"star-rate-s"])
    {
        
       [sender setImage:[UIImage imageNamed:@"star-s"]forState:UIControlStateNormal];
        [favoritesArray removeObject:url];
        [favorites removeObjectForKey:url];
        NSLog(@"index row%d   移除收藏 tag:%d", [path row],sender.tag);
    }
    else
    
    {
        [sender setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
        
        NSLog(@"index row%d   加入收藏 tag:%d", [path row],sender.tag);
    //NSLog(@"view:%@", [[[sender superview] superview] description]);
    
        [favoritesArray insertObject:url atIndex:0];
        [favorites setObject :rowData forKey:url];
    }
    [self.tableView reloadData];

    [[NSUserDefaults standardUserDefaults] setValue:favorites forKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] setValue:favoritesArray forKey:@"favoritesArray"];

     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (section==0) {
        //NewsDateViewController *newView= [NewsDateViewController new];
    //    segmentView.date=[NSDate date];
      
        
        
        //return segmentView.view;
                NewsDateViewController *newView= [NewsDateViewController new];
        newView.date=[NSDate date];
        
        return newView.view;
 
    }else{
      //  return segmentView.view;
        NewsDateViewController *newView= [NewsDateViewController new];
        NSDictionary *timeLine = [_storeNewsArray objectForKey:[NSString stringWithFormat:@"%li",(long)section]];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    
        NSDate *tempDate = [dateFormatter dateFromString:[timeLine objectForKey:@"date"]];
    
        newView.date=tempDate;
        
        return newView.view;

   }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==0) {
//         return segmentView.view.frame.size.height;
//    }else{
        return  newsDate.view.frame.size.height;
        //segmentView.view.frame.size.height;
//    }
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
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *heroSelected=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
//indexPath.row得到选中的行号，提取出在数组中的内容。
//    UIAlertView *myAlertView;
//    myAlertView = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:heroSelected delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
   // [myAlertView show];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    // 通过storyboard id拿到目标控制器的对象
//    ScrollViewDetailViewController *view =  [storyboard instantiateViewControllerWithIdentifier:@"ScrollViewDetailViewController"];
//    
//    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // 通过storyboard id拿到目标控制器的对象
   // ScrollViewDetailViewController *view =  [storyboard instantiateViewControllerWithIdentifier:@"ScrollViewDetailViewController"];
    NSArray *tempNews =  [[_storeNewsArray objectForKey:[NSString stringWithFormat:@"%li",(long)indexPath.section]] objectForKey:@"stories"];
    NSDictionary *rowData1 =tempNews[indexPath.row];
    NSLog(@"%@",rowData1);
    id i =[rowData1 objectForKey:@"share_url"];
    
    ////////////////浏览记录
   
    
    NSArray *imageurl =[rowData1 objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    [history setObject :rowData1 forKey:url];
    if ([historyArray count]>0) {
        if (![historyArray[0] isEqualToString:url]) {
            [historyArray insertObject:url atIndex:0];  ///////储存历史记录的顺序 mutabledic不能记录顺序
            //////////保存多次浏览的记录 允许重复
            
        }
    }else
    {
        [historyArray insertObject:url atIndex:0];  ///////储存历史记录的顺序 mutabledic不能记录顺序

    }
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:historyArray forKey:@"historyArray"];
    [[NSUserDefaults standardUserDefaults] setValue:history forKey:@"history"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];

 //  view.url = [rowData1 objectForKey:@"share_url"];
   
 
    
    //  view.url = [rowData1 objectForKey:@"share_url"];
    //view.url =[NSString stringWithFormat:@"%@",i];
    
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",i]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
    
    
    
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"http://news-at.zhihu.com/api/3/news/latest"]) {
        
    
    NSDictionary *timeLine = result;
    [_storeNewsArray setObject:timeLine forKey:[NSString stringWithFormat:@"0"]];
     self.news = [timeLine objectForKey:@"stories"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMdd"];
                date = [dateFormatter dateFromString:[timeLine objectForKey:@"date"]];
               //date = [dateFormatter dateFromString:@"20001125"];
    
               // NSLog(@"%@\n   %ld",self.news,[self.news count]);
                NSLog(@"更新成功");
               [self.tableView headerEndRefreshing];
                NSMutableArray *indexImages=[[NSMutableArray alloc]init];
               NSMutableArray *title=[[NSMutableArray alloc]init];
               for (int i = 0; i<4; i++)
               {
                    NSDictionary *rowData = self.news[i];
                    NSArray *imageurl =[rowData objectForKey:@"images"];
                  NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
                    if (url) {
                        // [cell creatThread:url];
                        UIImageView *temp=[UIImageView new];
                        if (!picState) {
                            
                       
                            [temp setImageURLStr:url
                                     placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                        }else{
                            [temp setImageURLStr:nil
                                     placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                        }
                        
                        
                        [indexImages addObject:temp];
                       [title addObject:[rowData objectForKey:@"title"] ];
                       NSLog(@"%ld1111",(unsigned long)[indexImages count]);
                    }
                }
        
        
    
    
//                EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 175)
//                                                                     ImageArray:indexImages
//                                       // [NSArray arrayWithObjects:@"Expression_1@2x.png",@"Expression_2@2x.png",@"Expression_3@2x.png", nil]
//                                                                      TitleArray:title
//                                      //  [NSArray arrayWithObjects:@"11",@"22",@"33", @"33", @"33", @"33", @"33", @"33", nil]
//                                         ];
//                scroller.delegate=self;
//                self.tableView.tableHeaderView= scroller;
////
         JScrollView_PageControl_AutoScroll *scroller=[[JScrollView_PageControl_AutoScroll alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
        scroller.autoScrollDelayTime=3.0;
        scroller.delegate=self;
        [scroller setViewsArray:indexImages];
        [scroller shouldAutoShow:YES];
        self.tableView.tableHeaderView= scroller;
       
                [[NSUserDefaults standardUserDefaults]setObject:_storeNewsArray forKey:@"storeNewsArray"];
                [self.tableView reloadData];

    }
    
    else
    {
        NSDictionary *timeLine = result;
        NSDate *findInDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*(loadDayFlag)];
        [_storeNewsArray setObject:timeLine forKey:[NSString stringWithFormat:@"%i",loadDayFlag]];
        [storeNewsByDate setObject:timeLine forKey:[self stringFromDate:findInDay]];
        
        // self.news = [timeLine objectForKey:@"stories"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        date = [dateFormatter dateFromString:[timeLine objectForKey:@"date"]];
        //date = [dateFormatter dateFromString:@"20001125"];
        
        // NSLog(@"%@\n   %ld",self.news,[self.news count]);
        NSLog(@"更新成功");
        [self.tableView footerEndRefreshing];
        NSMutableArray *indexImages=[[NSMutableArray alloc]init];
        NSMutableArray *title=[[NSMutableArray alloc]init];
        for (int i = 0; i<[self.news count]; i++)
        {
            NSDictionary *rowData = self.news[i];
            NSArray *imageurl =[rowData objectForKey:@"images"];
            NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
            if (url) {
                // [cell creatThread:url];
                [indexImages addObject:url];
                [title addObject:[rowData objectForKey:@"title"] ];
                NSLog(@"%ld1111",(unsigned long)[indexImages count]);
            }
        }
        
        
        //loadDayFlag++;
        
        
        
        
        [[NSUserDefaults standardUserDefaults]setObject:storeNewsByDate forKey:@"storeNewsByDate"];
        [self.tableView reloadData];

        
    }
    
}
//////////////////json 下载数据/////////////////////////////
-(void)getData
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("download data", NULL);
   
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://news-at.zhihu.com/api/3/news/latest"
                                                       httpMethod:@"GET"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];

    dispatch_async(downloadQueue, ^{
       
             
        
        
        
        
//        NSMutableString *url = [[NSMutableString alloc]initWithString:@"http://news-at.zhihu.com/api/3/news/latest"];
//        //[url appendFormat:@"?access_token=%@&count=30",self.access_token];
//        NSData *userdata = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
//        
//        NSError *error=nil;
//        NSDictionary *timeLine = [NSJSONSerialization JSONObjectWithData:userdata options:NSJSONReadingAllowFragments error:&error];
//        //[NSJSONSerialization JSONObjectWithData:userdata options:kNilOptions error:&error];
//        if (error) {
//                  NSLog(@"dic->%@",error);
//        }
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_storeNewsArray setObject:timeLine forKey:[NSString stringWithFormat:@"0"]];
//            self.news = [timeLine objectForKey:@"stories"];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyyMMdd"];
//            date = [dateFormatter dateFromString:[timeLine objectForKey:@"date"]];
//           //date = [dateFormatter dateFromString:@"20001125"];
//         
//           // NSLog(@"%@\n   %ld",self.news,[self.news count]);
//            NSLog(@"更新成功");
//            [self.tableView headerEndRefreshing];
//            NSMutableArray *indexImages=[[NSMutableArray alloc]init];
//            NSMutableArray *title=[[NSMutableArray alloc]init];
//            for (int i = 0; i<3; i++)
//            {
//                NSDictionary *rowData = self.news[i];
//                NSArray *imageurl =[rowData objectForKey:@"images"];
//                NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
//                if (url) {
//                    // [cell creatThread:url];
//                    [indexImages addObject:url];
//                    [title addObject:[rowData objectForKey:@"title"] ];
//                    NSLog(@"%ld1111",(unsigned long)[indexImages count]);
//                }
//            }
//            
//            
//            
//            
//            EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 175)
//                                                                  ImageArray:indexImages
//                                   // [NSArray arrayWithObjects:@"Expression_1@2x.png",@"Expression_2@2x.png",@"Expression_3@2x.png", nil]
//                                                                  TitleArray:title
//                                   //  [NSArray arrayWithObjects:@"11",@"22",@"33", @"33", @"33", @"33", @"33", @"33", nil]
//                                     ];
//            scroller.delegate=self;
//            self.tableView.tableHeaderView= scroller;
//
//            [[NSUserDefaults standardUserDefaults]setObject:_storeNewsArray forKey:@"storeNewsArray"];
//            [self.tableView reloadData];
//        });
    });
   }
///////////////////////////加载某天 更多内容////////////////////////////////////////////////////
-(void)getOneDayData
{
    
    {
    
    
        
        NSDate *whichDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*loadDayFlag];
        NSDate *findInDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*(loadDayFlag+1)];
        // if ([_storeNewsArray objectForKey:[NSString stringWithFormat:@"%i",loadDayFlag]]!=nil) {
        loadDayFlag++;
        if ([storeNewsByDate objectForKey:[self stringFromDate:findInDay]]!=nil) {////////从本地缓存获取数据
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_storeNewsArray setObject:[storeNewsByDate objectForKey:[self stringFromDate:findInDay]] forKey:[NSString stringWithFormat:@"%i",loadDayFlag]];
                [self.tableView footerEndRefreshing];
                [self.tableView reloadData];
                
            });
            
            NSLog(@"使用缓存数据~~~~~~%@",[self stringFromDate:findInDay]);
        }
        else{
            
            NSMutableString *url = [NSMutableString stringWithFormat:@"http://news.at.zhihu.com/api/3/news/before/%@",[self stringFromDate:whichDay]];
            
            SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:url
                                                               httpMethod:@"GET"
                                                                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]
                                                                 delegate:self];
            NSMutableSet *requests;
            [requests addObject:_request];
            [_request connect];
            
            
        }
    
    }
//    
//    
//    
//    
//    dispatch_queue_t downloadQueue = dispatch_queue_create("download data", NULL);
//
//     dispatch_async(downloadQueue, ^{
////        NSDate *whichDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*loadDayFlag];
//             // NSMutableArray *thisDayNews = [timeLine objectForKey:@"stories"];
//           NSDate *whichDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*loadDayFlag];
//              NSDate *findInDay = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)*(loadDayFlag+1)];
//             // if ([_storeNewsArray objectForKey:[NSString stringWithFormat:@"%i",loadDayFlag]]!=nil) {
//             loadDayFlag++;
//         if ([storeNewsByDate objectForKey:[self stringFromDate:findInDay]]!=nil) {////////从本地缓存获取数据
//             
//             dispatch_async(dispatch_get_main_queue(), ^{
//             [_storeNewsArray setObject:[storeNewsByDate objectForKey:[self stringFromDate:findInDay]] forKey:[NSString stringWithFormat:@"%i",loadDayFlag]];
//              [self.tableView footerEndRefreshing];
//             [self.tableView reloadData];
//            
//           });
//             
//             NSLog(@"使用缓存数据~~~~~~%@",[self stringFromDate:findInDay]);
//         }
//         
//         else
//         {
//             //   }
//        NSMutableString *url = [NSMutableString stringWithFormat:@"http://news.at.zhihu.com/api/3/news/before/%@",[self stringFromDate:whichDay]];
//         NSData *userdata = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
//         
//         NSError *error;
//         NSDictionary *timeLine = [NSJSONSerialization JSONObjectWithData:userdata options:kNilOptions error:&error];
//
//         dispatch_async(dispatch_get_main_queue(), ^{
//           
//             
//             //[url appendFormat:@"?access_token=%@&count=30",self.access_token];
//        
//           
//          
//            [_storeNewsArray setObject:timeLine forKey:[NSString stringWithFormat:@"%i",loadDayFlag]];
//             [storeNewsByDate setObject:timeLine forKey:[self stringFromDate:findInDay]];
//            
//             // self.news = [timeLine objectForKey:@"stories"];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyyMMdd"];
//        date = [dateFormatter dateFromString:[timeLine objectForKey:@"date"]];
//        //date = [dateFormatter dateFromString:@"20001125"];
//        
//        // NSLog(@"%@\n   %ld",self.news,[self.news count]);
//        NSLog(@"更新成功");
//        [self.tableView footerEndRefreshing];
//        NSMutableArray *indexImages=[[NSMutableArray alloc]init];
//        NSMutableArray *title=[[NSMutableArray alloc]init];
//        for (int i = 0; i<[self.news count]; i++)
//        {
//            NSDictionary *rowData = self.news[i];
//            NSArray *imageurl =[rowData objectForKey:@"images"];
//            NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
//            if (url) {
//                // [cell creatThread:url];
//                [indexImages addObject:url];
//                [title addObject:[rowData objectForKey:@"title"] ];
//                NSLog(@"%ld1111",(unsigned long)[indexImages count]);
//            }
//        }
//        
//
//         //loadDayFlag++;
//        
//        
//        
//             
//    [[NSUserDefaults standardUserDefaults]setObject:storeNewsByDate forKey:@"storeNewsByDate"];
//    [self.tableView reloadData];
//    });
//         }
//    
//});
//    

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
    [self getData];
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
       [self getOneDayData];
//
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//       // [self.tableView footerEndRefreshing];
//    });
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
//    NSString *messege = [NSString stringWithFormat:@"你点击了第%d个图片",index];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Default Alert View"message:messege delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    // [alertView show];
//    
//    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // 通过storyboard id拿到目标控制器的对象
    ScrollViewDetailViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"ScrollViewDetailViewController"];
    
    
    //  viewController.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
    
}
-(void)segmentControllDidClicked:(UIButton *)sender
{
    
    
        NSString *message=[NSString stringWithFormat:@"通过delegate点击了%@的按钮",sender.titleLabel.text];
       UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [myAlertView show];
    
}


///////转换为20140908格式///////////////////
- (NSString *)stringFromDate:(NSDate *)date1{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date1];
    
    
    
    
    return destDateString;
    
}
- (void)didClickPage:(JScrollView_PageControl_AutoScroll *)view atIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    NSArray *tempNews =  [[_storeNewsArray objectForKey:[NSString stringWithFormat:@"0"]] objectForKey:@"stories"];
    NSDictionary *rowData1 =tempNews[index];
    NSLog(@"%@",rowData1);
    id i =[rowData1 objectForKey:@"share_url"];
    
    ////////////////浏览记录
    
    
    NSArray *imageurl =[rowData1 objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    [history setObject :rowData1 forKey:url];
    
    [history setObject :rowData1 forKey:url];
    if ([historyArray count]>0) {
        if (![historyArray[0] isEqualToString:url]) {
            [historyArray insertObject:url atIndex:0];  ///////储存历史记录的顺序 mutabledic不能记录顺序
            //////////保存多次浏览的记录 允许重复
            
        }
    }else
    {
        [historyArray insertObject:url atIndex:0];  ///////储存历史记录的顺序 mutabledic不能记录顺序
        
    }
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:historyArray forKey:@"historyArray"];
    [[NSUserDefaults standardUserDefaults] setValue:history forKey:@"history"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    
    //  view.url = [rowData1 objectForKey:@"share_url"];
    
    
    
    //  view.url = [rowData1 objectForKey:@"share_url"];
    //view.url =[NSString stringWithFormat:@"%@",i];
    
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",i]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end