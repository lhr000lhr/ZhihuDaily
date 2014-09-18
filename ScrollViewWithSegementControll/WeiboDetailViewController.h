//
//  WeiboDetailViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
@interface WeiboDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *content;
@property(strong,nonatomic)NSDictionary *rowData;
@property (strong, nonatomic) IBOutlet UIImageView *weiboImage;

@end
