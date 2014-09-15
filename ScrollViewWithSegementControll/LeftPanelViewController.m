//
//  LeftPanelViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-12.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "LeftPanelViewController.h"

@interface LeftPanelViewController ()

@end

@implementation LeftPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)switchViewController:(UIButton *)sender {
    
   
    switch (sender.tag) {
        case 101:
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"]
                                                        animated:YES];
           [self.sideMenuViewController hideMenuViewController];
            break;
      case 102:
        {   UITabBarController *i=[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];;
            [i setSelectedIndex:1];
            [self.sideMenuViewController setContentViewController:i
                                                         animated:YES];
        
            }
//
//           [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
//                                                        animated:YES];
          [self.sideMenuViewController hideMenuViewController];
            break;
        case 103:
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesTableViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 104 :
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}
@end
