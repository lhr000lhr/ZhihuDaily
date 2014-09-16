//
//  AppDelegate.m
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "AppDelegate.h"
#import "SinaWeibo.h"

#import "OneViewController.h"
@interface AppDelegate ()
            

@end

@implementation AppDelegate
@synthesize sinaweibo;
@synthesize viewController = _viewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//  //  LeftViewController * left = [[LeftViewController alloc]init];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UITabBarController *main  =  [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//    
// //   RightViewController * right = [[RightViewController alloc]init];
//    
//    WWSideslipViewController * slide = [[WWSideslipViewController alloc]initWithLeftView:[UIViewController new] andMainView:main andRightView:[UIViewController new]   andBackgroundImage:[UIImage imageNamed:@"bg.png"]];
//    
//    //滑动速度系数
//    [slide setSpeedf:0.5];
//    
//    //点击视图是是否恢复位置
//    slide.sideslipTapGes.enabled = YES;
////    [slide addChildViewController:main];
////    [main didMoveToParentViewController:slide];
//    [self.window setRootViewController:slide];
//    
//    [self.window makeKeyAndVisible];
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self.viewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}
@end
