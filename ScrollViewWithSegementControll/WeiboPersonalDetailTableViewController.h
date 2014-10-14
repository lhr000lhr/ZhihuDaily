//
//  WeiboPersonalDetailTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-13.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboPersonalDetailViewController.h"
#import "SinaWeibo.h"
#import "OneViewController.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "MBProgressHUD.h"
#import "TQRichTextView.h"

@interface WeiboPersonalDetailTableViewController : UITableViewController<SinaWeiboRequestDelegate,SinaWeiboDelegate,MBProgressHUDDelegate,TQRichTextViewDelegate>
{
   
    BOOL _reloading;
    NSString * since_id;
    NSString * max_id;
    NSMutableArray *Commentslist;
    CCAVSegmentController *segmentView;
    BOOL loadingMore;
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
    int  Page;
    BOOL iMage;
    BOOL isflage;

    BOOL isPic;
    MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
}

@property(strong, nonatomic) NSString *WeiboId;

@property (strong ,nonatomic) NSString *screenName;
@end
