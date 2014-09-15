//
//  CCAVSegmentController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-10.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "CCAVSegmentController.h"

@interface CCAVSegmentController ()

@end

@implementation CCAVSegmentController

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
    [self setLableDate:[NSDate date]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
//    
//    NSString *message=[NSString stringWithFormat:@"你点击了%@的按钮",sender.titleLabel.text];
//    UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [myAlertView show];
    if ([_delegate respondsToSelector:@selector(segmentControllDidClicked:)]) {
        [_delegate segmentControllDidClicked:sender];
    }
    
    
}

-(void)setLableDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    self.newsDate.text = destDateString;
    
}


- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    
    
    return destDateString;
    
}

@end
