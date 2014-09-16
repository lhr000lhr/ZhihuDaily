//
//  ViewController.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
@interface ViewController : UIViewController
{
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
}
@end
