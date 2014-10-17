//
//  CCTVGeneralThreadTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
#import "TQRichTextView.h"
#import "TTTAttributedLabel.h"
@interface CCTVGeneralThreadTableViewController : UITableViewController<SinaWeiboRequestDelegate,TQRichTextViewDelegate,TTTAttributedLabelDelegate>
{
    NSMutableDictionary *receivedData;
    NSMutableDictionary *storeHeight;
}
@property (strong , nonatomic)NSDictionary *rowData;
@end
