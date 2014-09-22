//
//  WeiboDetailViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-18.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "ScrollViewDetailViewController.h"
@interface WeiboDetailViewController ()

@end

@implementation WeiboDetailViewController

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
    CALayer *userImage = [self.userImage layer];   //获取ImageView的层
    [userImage setMasksToBounds:YES];
    [userImage setCornerRadius:6.0];
    CALayer *weiboImage = [self.weiboImage layer];   //获取ImageView的层
    [weiboImage setMasksToBounds:YES];
    [weiboImage setCornerRadius:6.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yourHandlingCode:)];
    [self.weiboImage addGestureRecognizer:singleTap];
    [self.userImage setImageWithURL:[NSURL URLWithString:[[self.rowData objectForKey:@"user"] objectForKey:@"profile_image_url"]]];
   [self.weiboImage setImageWithURL: [NSURL URLWithString: [self.rowData objectForKey:@"bmiddle_pic"]]];
    self.name.text=  [[self.rowData objectForKey:@"user"] objectForKey:@"name"];
    self.time.text=  [self.rowData objectForKey:@"created_at"];
    self.content.text=[self.rowData objectForKey:@"text"];
    
    
    
    
    NSArray *picsArray =[self.rowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
    
    
    
    NSString *from =[self.rowData objectForKey:@"source"];
    NSArray * array = [from componentsSeparatedByString:@"\">"];
    NSString *temp = array[1];
    array = [temp componentsSeparatedByString:@"<"];
    from = array[0];
    self.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
    
    if ([from isEqualToString:@"知乎Plus"]) {
        self.from.textColor=[UIColor orangeColor];
    }else{
        self.from.textColor=[UIColor lightGrayColor];
    }
    
    CGRect orgRect=self.content.frame;
    CGSize  size = [[self.rowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+20;
    self.content.frame=orgRect;
    
    CGRect frame = self.weiboImage.frame;
    frame.origin.y = self.content.frame.size.height + self.content.frame.origin.y+10.f;
    self.weiboImage.frame = frame;
    
    
    for (int i=0; i<[picsArray count]; i++) {
        
        UIImageView *weiboImage1 = [UIImageView new];
        
        
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
        [weiboImage1 setImageWithURL:[NSURL URLWithString:transferUrl]];
        
        
        CALayer *weiboImage = [weiboImage1 layer];   //获取ImageView的层
        [weiboImage setMasksToBounds:YES];
        [weiboImage setCornerRadius:6.0];
        
       
        weiboImage1.frame=frame;
        
        frame.origin.x = frame.origin.x +88;
        
      
        
        [self.view addSubview:weiboImage1];
        
        
        if (i==2) {
            frame = self.weiboImage.frame;
            frame.origin.y = frame.origin.y+88;
            
            
        }
        if (i==5) {
            frame.origin.x =self.weiboImage.frame.origin.x;
            frame.origin.y = frame.origin.y+88;
        }
    }
    
    
    
    
  
    
    
    
    
    
    
    frame = self.view.frame;
    if ([NSURL URLWithString: [self.rowData objectForKey:@"bmiddle_pic"]]==nil) {
        
        frame.size.height = self.content.frame.size.height + self.content.frame.origin.y+10.f;
        self.view.frame= frame;

    }else{
        
        int height = 0;
        
  //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
        if ([picsArray count]>6) {
            
            height = 88;
          //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        if ([picsArray count]>3) {
            height = height +88;
             // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        
            
            
            frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f+height;
        
            
            self.view.frame= frame;
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)yourHandlingCode:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView *)[gestureRecognizer view];
    //    int tagvalue = view.tag;
    //    int section = tagvalue/10000;
    //    int row = tagvalue- section*10000;
    NSString *url=[self.rowData objectForKey:@"original_pic"];
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",url]];
    //  webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
