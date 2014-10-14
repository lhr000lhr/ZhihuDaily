//
//  TextAndPicturesViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-14.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "TextAndPicturesViewController.h"

@interface TextAndPicturesViewController ()

@end

@implementation TextAndPicturesViewController




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
    self.title =@"CCTV";
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://192.168.1.35/cctvapi/thread/forum"
                                                       httpMethod:@"POST"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"forum_id",@"1",@"sort",@"0",@"offset",@"0",@"type",nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
    
    
    
    listItems = [NSArray new];
    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [self.postList registerNib:nib forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    
    listItems = [result objectForKey:@"items"];

    NSLog(@"%@",result[@"error"]);
        
        
        
        
  
    
    [self.postList reloadData];
    
    
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                forIndexPath:indexPath];
    
    
    
   
    NSDictionary *rowData = listItems[indexPath.row];
    
    cell.major.text = [rowData objectForKey:@"name"];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    return listItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
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
