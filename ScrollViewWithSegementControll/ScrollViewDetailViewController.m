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
//    NSURL *url1 =[NSURL URLWithString:self.url];
//    NSLog(@"%@",self.url);
//    NSURLRequest *request =[NSURLRequest requestWithURL:url1];
//    [self.WebView loadRequest:request];
    // Do any additional setup after loading the view.
//    [self.WebView loadHTMLString:self.url baseURL:nil];//加载html字符串到UIWebView上(该方法极为重要)

    
    
    [self requestDetail];
    
    
    
    
}

-(void)requestDetail
{
    

    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/news/%@",self.idNumber]
                                                       httpMethod:@"GET"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];

    

    
    
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    dic = result;
    
    if ([dic objectForKey:@"body"]) {
        
        
        
        
        
//        [self.WebView loadHTMLString:[dic objectForKey:@"body"] baseURL:nil];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[dic objectForKey:@"share_url"]]];
            [self.WebView loadRequest:request];
    }
    
    
    
    
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
