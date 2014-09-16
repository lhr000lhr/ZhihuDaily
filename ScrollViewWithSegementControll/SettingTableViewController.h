//
//  SettingTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "WeiboViewController.h"
#import "OneViewController.h"
@interface SettingTableViewController : UITableViewController
- (IBAction)settingSwitch:(UISwitch *)sender;
- (void) sendEmail:(NSString *)phoneNumber;
-(void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;




@property (strong, nonatomic) IBOutlet UISwitch *picState;
@property (strong, nonatomic) IBOutlet UISwitch *downLoadState;

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property(strong,nonatomic) WeiboViewController *weibo;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@end
