//
//  TwoViewController.m
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "TwoViewController.h"
#import "DoctorTableViewCell.h"
@interface TwoViewController ()

@end

@implementation TwoViewController
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
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"historyArray"];
    historyArray = [NSMutableArray arrayWithArray:tempArray];
    storeFavorites = [NSMutableArray new];
    for (NSString *key in favorites) {
        NSLog(@"%@ - %@", key, favorites[key]);
        [storeFavorites addObject:favorites[key]];
    }
    temp = [NSDictionary new];
    temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
    history =[NSMutableDictionary dictionaryWithDictionary:temp];
    tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"favoritesArray"];
    favoritesArray = [NSMutableArray arrayWithArray:tempArray];
    
    storeHistory = [NSMutableArray new];
    for (NSString *key in historyArray) {
        NSLog(@"%@ - %@", key, history[key]);
        [storeHistory addObject:history[key]];
    }
    
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
												 name:@"reloadData"
                                               object:nil];
    [self reloadData];
//    NSDictionary *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"];
//    favorites =[NSMutableDictionary dictionaryWithDictionary:temp];
//    storeFavorites = [NSMutableArray new];
//    for (NSString *key in favorites) {
//        NSLog(@"%@ - %@", key, favorites[key]);
//        [storeFavorites addObject:favorites[key]];
//    }
//    temp = [NSDictionary new];
//    temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
//    history =[NSMutableDictionary dictionaryWithDictionary:temp];
//    storeHistory = [NSMutableArray new];
//    for (NSString *key in history) {
//        NSLog(@"%@ - %@", key, history[key]);
//        [storeHistory addObject:history[key]];
//     
//    }
//    storeHistory;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    // Configure the cell...
//    storeHistory = [NSMutableArray new];
//    for (NSString *key in history) {
//        NSLog(@"%@ - %@", key, history[key]);
//        [storeHistory addObject:history[key]];
//    }
//    
    NSDictionary *rowData =storeHistory[indexPath.row];
    //self.news[indexPath.row];
    cell.Name.text=[rowData objectForKey:@"title"] ;
    cell.major.text=[rowData objectForKey:@"title"] ;
    cell.DoctorImage.image = [UIImage imageNamed:@"Expression_1"];
    NSArray *imageurl =[rowData objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    cell.stars.tag=indexPath.section*10000+indexPath.row;///// 设置 star的tag
    
    // [cell.stars addTarget:self action:@selector(addStars:) forControlEvents:UIControlEventTouchUpInside];
    if (url) {
        // [cell creatThread:url];
        
        [cell.DoctorImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Expression_1.png"]];
    }
    [cell.stars setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
    
    
    if ([favorites objectForKey:url]) {//////////设置收藏星星显示
        [cell.stars setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
        [cell.major setTextColor: [UIColor blueColor]];
        
    }else
    {
        [cell.stars setImage:[UIImage imageNamed:@"star-s"]forState:UIControlStateNormal];
        
        [cell.major setTextColor:[UIColor darkGrayColor]];
        
    }

    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *heroSelected=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    //indexPath.row得到选中的行号，提取出在数组中的内容。
    UIAlertView *myAlertView;
    myAlertView = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:heroSelected delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    // [myAlertView show];
    //
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //    // 通过storyboard id拿到目标控制器的对象
    //    ScrollViewDetailViewController *view =  [storyboard instantiateViewControllerWithIdentifier:@"ScrollViewDetailViewController"];
    //
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // 通过storyboard id拿到目标控制器的对象
    // ScrollViewDetailViewController *view =  [storyboard instantiateViewControllerWithIdentifier:@"ScrollViewDetailViewController"];
    
    NSDictionary *rowData1 =storeHistory[indexPath.row];
    NSLog(@"%@",rowData1);
    id i =[rowData1 objectForKey:@"share_url"];
    //  view.url = [rowData1 objectForKey:@"share_url"];
    //view.url =[NSString stringWithFormat:@"%@",i];
    
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",i]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];}





- (IBAction)cleanHistory:(id)sender {
     UIActionSheet *sheet;
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"清空" otherButtonTitles:@"取消", nil];


    sheet.tag = 255;
    
    [sheet showInView:self.view];
//    history = [NSMutableDictionary new];
//    [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"history"];
//    [self.tableView reloadData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];

}
#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
     if (actionSheet.tag == 255) {
         switch (buttonIndex) {
             {
             case 0:
                 history = [NSMutableDictionary new];
                 [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"history"];
                 historyArray = [NSMutableArray new];
                 [[NSUserDefaults standardUserDefaults]setObject:historyArray forKey:@"historyArray"];

                 [self.tableView reloadData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];            
                 break;
                 
             case 1:
                  return;
             }
                            }
                                }
}
@end
