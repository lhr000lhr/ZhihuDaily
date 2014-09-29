//
//  LeftPanelViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-12.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface LeftPanelViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;

- (IBAction)switchViewController:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *weiboButton;

@end
