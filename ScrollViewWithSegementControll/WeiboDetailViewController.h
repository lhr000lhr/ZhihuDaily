//
//  WeiboDetailViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
#import "NSDate+MJ.h"
#import "WeiboDetailAndCommentTableViewController.h"
@interface WeiboDetailViewController : UIViewController
{
    NSMutableArray *pics;
    NSString * WeiboId;
    NSArray *WeiboContent;
}
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *content;
@property(strong,nonatomic)NSDictionary *rowData;
@property (strong, nonatomic) IBOutlet UIImageView *weiboImage;
@property (strong, nonatomic) IBOutlet UILabel *from;

@property (nonatomic,getter=isPlayGif)BOOL playGif;


@property (strong, nonatomic) IBOutlet UIView *retweetView;
@property (strong, nonatomic) IBOutlet UILabel *retweetFrom;
@property (strong, nonatomic) IBOutlet UILabel *retweetName;
@property (strong, nonatomic) IBOutlet UILabel *retweetTime;
@property (strong, nonatomic) IBOutlet UILabel *retweetContent;
@property (strong, nonatomic) IBOutlet UIImageView *retweetWeiboImage;

@end
