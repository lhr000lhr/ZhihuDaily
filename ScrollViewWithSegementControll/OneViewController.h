//
//  OneViewController.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "EScrollerView.h"
#import "CCAVSegmentController.h"
#import "NewsDateViewController.h"
#import "XBNavCustomButton.h"
@interface OneViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,CCAVSegmentControllerDelegate,EScrollerViewDelegate>
{
    CCAVSegmentController *segmentView;
    NewsDateViewController *newsDate;
    NSDate *date;
   // NSDictionary *storeNewsArray;
    int loadDayFlag;
    NSMutableDictionary *favorites;
     NSMutableArray *storeFavorites;
    NSMutableDictionary *history;
    NSMutableArray *storeHistory;
    NSMutableDictionary *storeNewsByDate;

}
@property(strong,nonatomic)NSMutableArray *news;
@property(strong,nonatomic)NSMutableDictionary *storeNewsArray;
//@property(strong,nonatomic)CCAVSegmentController *segmentView;
@end
