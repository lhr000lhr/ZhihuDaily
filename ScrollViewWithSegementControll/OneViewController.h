//
//  OneViewController.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIImageView+MJWebCache.h"
#import "UIImageView+WebCache.h"
#import "EScrollerView.h"
#import "CCAVSegmentController.h"
#import "NewsDateViewController.h"
#import "XBNavCustomButton.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "DoctorTableViewCell.h"
#import "DoctorDetailViewController.h"
#import "ScrollViewDetailViewController.h"
#import "CCAVSegmentController.h"
#import "NewsDateViewController.h"
#import "MJPhoto.h"
#import "JScrollView+PageControl+AutoScroll.h"
#import <POP/POP.h>
#import "ParallaxHeaderView.h"

@interface OneViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,CCAVSegmentControllerDelegate,EScrollerViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,JScrollViewViewDelegate>
{
    CCAVSegmentController *segmentView;
    NewsDateViewController *newsDate;
    NSDate *date;
   // NSDictionary *storeNewsArray;
    int loadDayFlag;
    BOOL picState;
    BOOL downLoadState;
    NSMutableDictionary *favorites;
    NSMutableArray *storeFavorites;
    NSMutableDictionary *history;
    NSMutableArray *storeHistory;
    NSMutableDictionary *storeNewsByDate;
    NSMutableArray *historyArray;
    NSMutableArray *favoritesArray;
    JScrollView_PageControl_AutoScroll *scroller;

}
@property(strong,nonatomic)NSMutableArray *news;
@property(strong,nonatomic)NSMutableDictionary *storeNewsArray;
//@property(strong,nonatomic)CCAVSegmentController *segmentView;
@end
