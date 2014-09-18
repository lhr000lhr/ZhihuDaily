//
//  PostWeiboViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
@interface PostWeiboViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,SinaWeiboAuthorizeViewDelegate>

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
- (IBAction)chooseImage:(id)sender;
- (IBAction)post:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textField;
@end
