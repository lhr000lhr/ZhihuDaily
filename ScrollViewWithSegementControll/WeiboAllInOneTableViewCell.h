//
//  WeiboAllInOneTableViewCell.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-19.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboDetailViewController.h"
@interface WeiboAllInOneTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *from;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *content;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *weiboImages;


@property (strong, nonatomic) IBOutlet UIView *retweetView;
@property (strong, nonatomic) IBOutlet UILabel *retweetFrom;
@property (strong, nonatomic) IBOutlet UILabel *retweetName;
@property (strong, nonatomic) IBOutlet UILabel *retweetTime;
@property (strong, nonatomic) IBOutlet UILabel *retweetContent;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *retweetWeiboImages;
//@property (strong, nonatomic) IBOutlet UIView *gap;


@property(strong,nonatomic) NSDictionary *rowData;
//@property (strong,nonatomic)WeiboDetailViewController *viewController;
@end
