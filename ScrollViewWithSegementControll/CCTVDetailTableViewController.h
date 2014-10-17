//
//  CCTVDetailTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
@interface CCTVDetailTableViewController : UITableViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    NSMutableDictionary *receivedData;
    NSArray *hot_thread;
}

@property (strong, nonatomic) IBOutlet UILabel *floor;
@property (strong , nonatomic) NSDictionary *rowData;
@end
