//
//  WeiboReviewViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-19.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface WeiboReviewViewController : UIViewController<SinaWeiboRequestDelegate,SinaWeiboDelegate>
{
    NSString *postStatusText;
    
    NSString *commentText;
}
@property (strong, nonatomic) IBOutlet UITextView *textField;
@property (retain, nonatomic) NSString *weiboid;
@property (retain,nonatomic) NSString *weibousername;
@end
