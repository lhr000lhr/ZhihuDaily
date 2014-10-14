//
//  TextAndPicturesViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-14.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "OneViewController.h"

@interface TextAndPicturesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>


{
    NSArray *listItems;
    
}

@property (strong, nonatomic) IBOutlet UITableView *postList;

@end
