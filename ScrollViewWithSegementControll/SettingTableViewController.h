//
//  SettingTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController

-(void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;
- (void) sendEmail:(NSString *)phoneNumber;
@end
