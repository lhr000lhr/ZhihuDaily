//
//  WeiboReviewViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-19.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboReviewViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "AppDelegate.h"
@interface WeiboReviewViewController ()

@end

@implementation WeiboReviewViewController

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
    if (self.weibousername==nil) {
        NSString *title = [NSString stringWithFormat:@"回复："];
        self.navigationItem.title =title;
    }else{
        NSString *title = [NSString stringWithFormat:@"回复%@：",self.weibousername];
        self.navigationItem.title =title;}
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Done"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(sendComment)];
    self.navigationItem.rightBarButtonItem = myButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"headerRereshing" object:nil];
        postStatusText = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"comments/create.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:postStatusText, @"comment",self.weiboid,@"id", nil]
                           httpMethod:@"POST"
                             delegate:self];
            NSLog(@"111");
            
            
        }
    }
}
static int post_status_times = 0;
- (IBAction)send:(id)sender {
    if (!postStatusText)
    {
        post_status_times ++;
        postStatusText = nil;
        postStatusText = [[NSString alloc] initWithFormat:@"回复@%@: %@",self.weibousername,self.textField.text];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    
    alertView.tag = 0;
    [alertView show];
    
    
}
- (void)sendComment{
    if (!postStatusText)
    {
        post_status_times ++;
        postStatusText = nil;
        if (self.weibousername !=nil) {
            postStatusText = [[NSString alloc] initWithFormat:@"回复@%@: %@",self.weibousername,self.textField.text];
        }else{
            postStatusText = [[NSString alloc] initWithFormat:@"%@",self.textField.text];
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    
    alertView.tag = 0;
    [alertView show];
    
    
}
@end
