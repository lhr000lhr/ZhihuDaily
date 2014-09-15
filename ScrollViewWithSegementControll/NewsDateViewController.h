//
//  NewsDateViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-10.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *newsDate;
@property(strong ,nonatomic) NSDate *date;
-(void)setLableDate:(NSDate *)date;
- (NSString *)stringFromDate:(NSDate *)date;
@end
