//
//  LeftPanelViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-12.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "AppDelegate.h"
#import "OneViewController.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:)
												 name:@"changeName" object:nil];
    SinaWeibo *sinaWeibo =[self sinaweibo];
    if ([sinaWeibo isAuthValid]) {
        NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        
        [self.userName setTitle:temp forState:UIControlStateNormal];
          [self.userImage setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url" ]]];
        //[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)test:(NSNotification*)notify
{
    NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if (temp) {
        [self.userName setTitle:temp forState:UIControlStateNormal];
        [self.userImage setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url" ]]];
    }else{
        [self.userName setTitle:@"使用新浪微博登陆" forState:UIControlStateNormal];
        [self.userImage setImage:[UIImage imageNamed:@"gen_share_sine"]];
    }
    
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
    
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
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"mainContentViewController"]
                                                        animated:YES];
           [self.sideMenuViewController hideMenuViewController];
            break;
      case 102:
        {   UITabBarController *i=[self.storyboard instantiateViewControllerWithIdentifier:@"mainContentViewController"];;
            [i setSelectedIndex:1];
            [self.sideMenuViewController setContentViewController:i
                                                         animated:YES];
        [self.sideMenuViewController hideMenuViewController];
            break;
            }
//
//           [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
//                                                        animated:YES];
          
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
        case 105 :
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"WeiboHomeLineTableViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}
@end
