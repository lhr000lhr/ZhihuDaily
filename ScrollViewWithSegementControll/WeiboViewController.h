//
//  WeiboViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-16.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
@interface WeiboViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,SinaWeiboAuthorizeViewDelegate>
{
    UIButton  *loginButton;
    UIButton *logoutButton;
    UIButton *userInfoButton;
    UIButton *timelineButton;
    UIButton *postStatusButton;
    UIButton *postImageStatusButton;
    UIImage *postImage;
    UITextField *text ;
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
    NSMutableArray *dataArray;
    NSMutableArray *homeline;
    NSMutableArray *tableviewlist;
    NSArray *WeiboContent;
    NSArray *user;
    NSMutableData *_data;
    NSDictionary *rowData;
    NSMutableArray * thumbnailPictureUrls;
    NSData *imageData2;
    NSDictionary *imageDictionary;
    NSString * profile_image; // 微博头像地址
    NSString * WeiboId;
    NSString * since_id;
    NSString * max_id;
    int  Page;
    BOOL iMage;
    BOOL isflage;
    BOOL _reloading;
    BOOL isPic;
    
}
@property (strong, nonatomic) IBOutlet UILabel *userName;
- (void)logoutButtonPressed;
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo;
@end
