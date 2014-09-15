//
//  FavoritesTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ScrollViewDetailViewController.h"
#import "DoctorTableViewCell.h"


@interface FavoritesTableViewController ()

@end
static NSString *CellIdentifier = @"Cell";
@implementation FavoritesTableViewController

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
    NSDictionary *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorites"];
    favorites =[NSMutableDictionary dictionaryWithDictionary:temp];
    storeFavorites = [NSMutableArray new];
    for (NSString *key in favorites) {
        NSLog(@"%@ - %@", key, favorites[key]);
        [storeFavorites addObject:favorites[key]];
    }
    
    NSLog(@"%@",storeFavorites);
    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [favorites count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    // Configure the cell...
    storeFavorites = [NSMutableArray new];
    for (NSString *key in favorites) {
        NSLog(@"%@ - %@", key, favorites[key]);
        [storeFavorites addObject:favorites[key]];
    }
    
    NSDictionary *rowData =storeFavorites[indexPath.row];
    //self.news[indexPath.row];
    cell.Name.text=[rowData objectForKey:@"title"] ;
    cell.major.text=[rowData objectForKey:@"title"] ;
    cell.DoctorImage.image = [UIImage imageNamed:@"Expression_1"];
    NSArray *imageurl =[rowData objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    cell.stars.tag=indexPath.section*10000+indexPath.row;///// 设置 star的tag
    
    [cell.stars addTarget:self action:@selector(addStars:) forControlEvents:UIControlEventTouchUpInside];
    if (url) {
        // [cell creatThread:url];
        
        [cell.DoctorImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Expression_1.png"]];
        NSLog(@"%@",NSHomeDirectory());
    }
    [cell.stars setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];

    
    return cell;
}

-(void)addStars :(UIButton *)sender
{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    long section = sender.tag/10000;
    long row = sender.tag- section*10000;
    
    NSDictionary *rowData =storeFavorites[row];
    NSArray *imageurl =[rowData objectForKey:@"images"];
    NSString *url =[NSString stringWithFormat:@"%@",imageurl[0]];
    
    
    if (sender.imageView.image ==[UIImage imageNamed:@"star-rate-s"])
    {
        
        [sender setImage:[UIImage imageNamed:@"star-s"]forState:UIControlStateNormal];
        
        [favorites removeObjectForKey:url];
        NSLog(@"index row%ld   移除收藏 tag:%ld", [path row],sender.tag);
    }
    else
        
    {
        [sender setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
        
        NSLog(@"index row%d   加入收藏 tag:%d", [path row],sender.tag);
        //NSLog(@"view:%@", [[[sender superview] superview] description]);
        
        
        [favorites setObject :rowData forKey:url];
    }
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setValue:favorites forKey:@"favorites"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
  
    NSDictionary *rowData1 =storeFavorites[indexPath.row];
    NSLog(@"%@",rowData1);
    id i =[rowData1 objectForKey:@"share_url"];
    //  view.url = [rowData1 objectForKey:@"share_url"];
  //view.url =[NSString stringWithFormat:@"%@",i];
   
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",i]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

@end
