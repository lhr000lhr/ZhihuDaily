//
//  ScrollViewDetailViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-3.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOWebViewController.h"
@interface ScrollViewDetailViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) NSString *url;
@end
