//
//  CCTVDetailTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "CCTVDetailTableViewController.h"
#import "CCTVGeneralThreadTableViewController.h"
@interface CCTVDetailTableViewController ()

@end

@implementation CCTVDetailTableViewController

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
    [self downLoadData];
    hot_thread = [NSArray new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)downLoadData
{
    
    
    
    NSString *tv_id = [self.rowData objectForKey:@"tv_id"];
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://58.68.243.109/cctvapi/tv/det"
                                                       httpMethod:@"POST"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:tv_id,@"tv_id", nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
    
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
 
    
    
    receivedData = result;
    
    NSMutableArray * hot_threadTemp = [receivedData objectForKey:@"hot_thread"];
    hot_thread = hot_threadTemp;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
  //  NSArray *insertIndexPath = [NSArray arrayWithObjects:indexPath, nil];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[hot_threadTemp count]];
    for (int ind = 0; ind < [[receivedData objectForKey:@"hot_thread"] count]; ind++) {
        NSInteger indexPathRow  = [hot_thread indexOfObject:[hot_threadTemp objectAtIndex:ind]];
        NSLog(@"indexPath Row:%d",indexPathRow);
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//   [self.tableView reloadData];
    
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
    return hot_thread.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentHotCell" forIndexPath:indexPath];
    NSDictionary *rowData = hot_thread[indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [rowData objectForKey:@"name"];
    cell.detailTextLabel.text = [rowData objectForKey:@"time"];
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //some functions
    
    NSDictionary *rowData = hot_thread[indexPath.row];

    NSString *type = [rowData objectForKey:@"type"];
    
    if ([type isEqualToString:@"1"]) {//1 普通贴, 2 竞猜贴, 3投票贴, 4抽奖贴 ,5 彩踩贴
        
        [self performSegueWithIdentifier:@"showThread" sender:indexPath];
        
        
    }
    
    
    else if ([type isEqualToString:@"6"]){
        NSString *url = [rowData objectForKey:@"game_web"];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",url]];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    // 取消选中状态

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
      if ([segue.identifier isEqualToString:@"showThread"]){
          NSIndexPath *indexPath = sender;
          NSDictionary *rowData = hot_thread[indexPath.row];
          CCTVGeneralThreadTableViewController *detailViewController = [segue destinationViewController];
          detailViewController.rowData = rowData;
          
      }
    
    
    
}


@end
