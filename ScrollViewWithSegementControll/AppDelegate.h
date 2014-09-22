//
//  AppDelegate.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
/**将下面注释取消，并定义自己的app key，app secret以及授权跳转地址uri
 此demo即可编译运行**/

#define kAppKey             @"2540558039"   //////浩然的小尾巴 知乎plus
#define kAppSecret          @"72c033f2459caa161e898aa19b8c5bee"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"
// #define kAppKey    @"3616522959"  //////浩然的机机
// #define kAppSecret   @"d124e9ba9c6abe8a2de181a396145a01"
// #define kAppRedirectURI   @"https://api.weibo.com/oauth2/default.html"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif
@class WeiboViewController;
@class SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,SinaWeiboAuthorizeViewDelegate>
{
    SinaWeibo *sinaweibo;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) WeiboViewController *viewController;
@end

