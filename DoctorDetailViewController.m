//
//  DoctorDetailViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-3.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "DoctorDetailViewController.h"

@interface DoctorDetailViewController ()

@end

@implementation DoctorDetailViewController

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
  //  self.url = [NSString stringWithFormat:@"http://www.qq.com" ];
    NSURL *url1 =[NSURL URLWithString:self.url];
    NSLog(@"%@",self.url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url1];
    [self.WebView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
