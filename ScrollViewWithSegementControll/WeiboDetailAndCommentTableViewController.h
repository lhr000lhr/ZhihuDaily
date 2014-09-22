//
//  WeiboDetailAndCommentTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
#import "CCAVSegmentController.h"
#import "WeiboHomeLineTableViewController.h"
@interface WeiboDetailAndCommentTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,CCAVSegmentControllerDelegate>
{
    BOOL _reloading;
    NSString * since_id;
    NSString * max_id;
    NSMutableArray *Commentslist;
    CCAVSegmentController *segmentView;
    BOOL loadingMore;
    
}
@property(strong, nonatomic) NSString *weiboContent;
@property(strong, nonatomic) NSString *weiboUserName;
@property(strong, nonatomic) NSString *weiboUserUrl;
@property(strong, nonatomic) NSData     *weiboImagesData;
@property(strong, nonatomic) NSString *original_pic;
@property(strong,nonatomic)  NSArray *weiboComments;
@property(strong, nonatomic) NSString *WeiboId;
@property(nonatomic) BOOL *getFlag;
@property(strong,nonatomic)NSDictionary *rowData;
@property(strong,nonatomic) UITableView *tableView;
- (IBAction)review:(id)sender;
@end
