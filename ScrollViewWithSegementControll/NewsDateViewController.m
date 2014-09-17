//
//  NewsDateViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-10.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "NewsDateViewController.h"

@interface NewsDateViewController ()

@end

@implementation NewsDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   //   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  // [formatter setDateFormat:@"yyyy年mm月dd"];
     //  NSLog(@"%@,,,,,,%@",date1,[formatter stringFromDate:date1]);
    self.newsDate.text =  [self stringFromDate:self.date];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    
    
    return destDateString;
    
}
-(void)setLableDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    self.newsDate.text = destDateString;
    
}



@end
