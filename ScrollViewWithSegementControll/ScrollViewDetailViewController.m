//
//  ScrollViewDetailViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-3.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "ScrollViewDetailViewController.h"

@interface ScrollViewDetailViewController ()

@end

@implementation ScrollViewDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [refreshBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setBackgroundImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
        self.navigationItem.leftBarButtonItem = refreshItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //self.url = [NSString stringWithFormat:@"http://www.qq.com" ];
    NSURL *url1 =[NSURL URLWithString:self.url];
    NSLog(@"%@",self.url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url1];
    [self.WebView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
