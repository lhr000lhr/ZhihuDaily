//
//  FavoritesTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesTableViewController : UITableViewController<UIAlertViewDelegate>
{
    NSMutableDictionary *favorites;
    NSMutableArray *storeFavorites;
    NSString *tempUrl;
}
@end
