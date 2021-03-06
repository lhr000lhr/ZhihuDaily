//
//  WeiboPersonalDetailViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-13.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "MBProgressHUD.h"
@interface WeiboPersonalDetailViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,MBProgressHUDDelegate>
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
    MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
}
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *friends;
@property (strong, nonatomic) IBOutlet UILabel *followers;
@property (strong, nonatomic) IBOutlet UILabel *statuses;

@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSString *screen_name;
@end
