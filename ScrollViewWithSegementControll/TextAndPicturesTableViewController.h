//
//  TextAndPicturesTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "OneViewController.h"
#import "NYSegmentedControl.h"
@interface TextAndPicturesTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,JScrollViewViewDelegate>
{
    NSArray *listItems;
    NSMutableDictionary *receivedData;
    JScrollView_PageControl_AutoScroll *scroller;
    NSMutableArray *hot_tv;
    NSMutableArray *hot_activity;
    NSMutableArray *hot_thread;
}
@property NYSegmentedControl *segmentedControl;

@end
