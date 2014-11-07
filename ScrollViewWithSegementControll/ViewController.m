//
//  ViewController.m
//  sinaweibo_ios_sdk_demo
//
//  Created by 浩然 on 14-7-17.
//  Copyright (c) 2014年 SINA. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//#import "BIDNameAndColorCell.h"
@interface ViewController ()

@end

@implementation ViewController

//static NSString *CellTableIdentifier = @"CellTableIdentifier";

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
- (void)loginButtonPressed
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

- (void)viewDidUnload {
    //[self setUsername:nil];
    [super viewDidUnload];
}

@end
