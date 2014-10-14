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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(test:)
												 name:@"changeName" object:nil];
    self.weiboButton.hidden = ![[NSUserDefaults standardUserDefaults]boolForKey:@"weiboState"];
    SinaWeibo *sinaWeibo =[self sinaweibo];
    if ([sinaWeibo isAuthValid]) {
        NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        
        [self.userName setTitle:temp forState:UIControlStateNormal];
        [self.userImage setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url" ]]];
        self.userImage.layer.masksToBounds =YES;
        self.userImage.layer.cornerRadius =50;
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
        self.userImage.layer.masksToBounds = YES; [self.userImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.userImage setClipsToBounds:YES];
        self.userImage.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.userImage.layer.shadowOffset = CGSizeMake(4.0, 4.0);
        self.userImage.layer.shadowOpacity = 0.5;
        self.userImage.layer.shadowRadius = 2.0;
        self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImage.layer.borderWidth = 2.0f;
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
        self.userImage.layer.masksToBounds =YES;    
        self.userImage.layer.cornerRadius =50;
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
        self.userImage.layer.masksToBounds = YES; [self.userImage setContentMode:UIViewContentModeScaleAspectFill];
        [self.userImage setClipsToBounds:YES];
        self.userImage.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.userImage.layer.shadowOffset = CGSizeMake(4.0, 4.0);
        self.userImage.layer.shadowOpacity = 0.5;
        self.userImage.layer.shadowRadius = 2.0;
        self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userImage.layer.borderWidth = 2.0f;
    }else{
        [self.userName setTitle:@"使用新浪微博登陆" forState:UIControlStateNormal];
        [self.userImage setImage:[UIImage imageNamed:@"gen_share_sine"]];
    }
    
    self.weiboButton.hidden= ![[NSUserDefaults standardUserDefaults]boolForKey:@"weiboState"];
    
    
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
        case 106 :
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TextAndPicturesViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}
@end
