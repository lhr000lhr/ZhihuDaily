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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    /*  if (nil == cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     */ // cell.textLabel.text = @"111";
    cell.Name.text=@"Name";
    cell.DoctorImage.image = [UIImage imageNamed:@"Expression_1"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;

}
@end
