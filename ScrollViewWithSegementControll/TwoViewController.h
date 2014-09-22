//
//  TwoViewController.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
#import "DoctorTableViewCell.h"
#import "DoctorDetailViewController.h"
#import "ScrollViewDetailViewController.h"
#import "ScrollViewDetailViewController.h"
#import "CCAVSegmentController.h"
#import "NewsDateViewController.h"
@interface TwoViewController : UITableViewController<UIActionSheetDelegate>
{
    NSMutableDictionary *favorites;
    NSMutableArray *storeFavorites;
    NSMutableDictionary *history;
    NSMutableArray *storeHistory;

}
@property(strong,nonatomic)NSMutableDictionary *storeNewsArray;
@end
