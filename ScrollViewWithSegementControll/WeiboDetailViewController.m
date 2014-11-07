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
//    CALayer *userImage = [self.userImage layer];   //获取ImageView的层
//    [userImage setMasksToBounds:YES];
//    [userImage setCornerRadius:6.0];
//    CALayer *weiboImage = [self.weiboImage layer];   //获取ImageView的层
//    [weiboImage setMasksToBounds:YES];
//    [weiboImage setCornerRadius:6.0];
    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
  //  [self.weiboImage addGestureRecognizer:singleTap];
    
    NSString * userImageUrl =[[self.rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSArray * array1 = [userImageUrl componentsSeparatedByString:@"/50/"];
    NSString *new = [NSString stringWithFormat:@"%@/180/%@",array1[0],array1[1]];
    
    [self.userImage setImageWithURL:[NSURL URLWithString:new]];
    [self.weiboImage setImageWithURL: [NSURL URLWithString: [self.rowData objectForKey:@"bmiddle_pic"]]];
    self.name.text=  [[self.rowData objectForKey:@"user"] objectForKey:@"name"];
    self.time.text=  [self.rowData objectForKey:@"created_at"];
    self.content.text=[self.rowData objectForKey:@"text"];
    
    self.time.text = [self getTimeString:[self.rowData objectForKey:@"created_at"]];
    NSArray *picsArray =[self.rowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
    
    
    
    NSString *from =[self.rowData objectForKey:@"source"];
    if (from.length>5) {
        NSArray * array = [from componentsSeparatedByString:@"\">"];
        NSString *temp = array[1];
        array = [temp componentsSeparatedByString:@"<"];
        from = array[0];
        self.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
        
    }
   
    if ([self.from.text isEqualToString:@"来自知乎Plus"]||[self.from.text isEqualToString:@"来自浩然的小尾巴"]) {
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
        weiboImage1.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [weiboImage1 addGestureRecognizer:singleTap];
        weiboImage1.tag=0+i+100;
        
        
        
        
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
      
        NSString *fileName = [transferUrl lastPathComponent];
        if ([fileName hasSuffix:@".gif"]&&(!self.playGif)) {
            transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
        }
            [weiboImage1 setBackgroundColor:[UIColor darkGrayColor]];
        [weiboImage1 setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
        
        
        CALayer *weiboImage = [weiboImage1 layer];   //获取ImageView的层
        [weiboImage setMasksToBounds:YES];
        [weiboImage setCornerRadius:0.0];
        
        weiboImage1.contentMode = UIViewContentModeScaleAspectFill;
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
    
/////////////////////////////转发内容布局、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
    
    if ([self.rowData objectForKey:@"retweeted_status"]!=nil) {
        
        
        NSDictionary *retweetRowData = [self.rowData objectForKey:@"retweeted_status"];
        self.retweetView.hidden=NO;
        frame = self.retweetView.frame;
      //  frame.size.height =self.content.frame.size.height + self.content.frame.origin.y+10.f;
        frame.origin.y =self.content.frame.size.height + self.content.frame.origin.y+10.f;

        self.retweetView.frame = frame;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetViewDetail:)];
        [self.retweetView addGestureRecognizer:singleTap];
        
        self.retweetName.text = [[retweetRowData objectForKey:@"user"] objectForKey:@"name"];
        self.retweetTime.text=  [self getTimeString:[retweetRowData objectForKey:@"created_at"]];
        self.retweetContent.text=[retweetRowData objectForKey:@"text"];
        
        
        
        
        CGRect orgRect=self.retweetContent.frame;
        CGSize  size = [[retweetRowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        orgRect.size.height=size.height+20;
        self.retweetContent.frame=orgRect;
        
        
        size=[[[retweetRowData objectForKey:@"user"] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        frame = self.retweetFrom.frame;
        frame.origin.x = size.width + self.retweetName.frame.origin.x +10;
        self.retweetFrom.frame= frame;
        
        
        
        NSString *retweetFrom =[retweetRowData objectForKey:@"source"];///////来源处理////////
        if (retweetFrom.length>5) {
            
        
        NSArray * retweetArray = [retweetFrom componentsSeparatedByString:@"\">"];
        NSString *retweetTemp = retweetArray[1];
        retweetArray = [retweetTemp componentsSeparatedByString:@"<"];
        retweetFrom = retweetArray[0];
        self.retweetFrom.text =[NSString stringWithFormat:@"来自%@",retweetArray[0]];///////来源处理////////
        }
        
        if ([self.from.text isEqualToString:@"来自知乎Plus"]||[self.from.text isEqualToString:@"来自浩然的小尾巴"]){
            self.retweetFrom.textColor=[UIColor orangeColor];
        }else{
            self.retweetFrom.textColor=[UIColor lightGrayColor];
        }
        
        
        
        frame = self.retweetWeiboImage.frame;
        frame.origin.y = self.retweetContent.frame.size.height + self.retweetContent.frame.origin.y+10.f;
        self.retweetWeiboImage.frame = frame;
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
        
        for (int i=0; i<[retweetPicsArray count]; i++) {
            
            UIImageView *weiboImage1 = [UIImageView new];
            weiboImage1.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [weiboImage1 addGestureRecognizer:singleTap];
            
            weiboImage1.tag=0+i+100;
           
            
            
            
            NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
            NSString *fileName = [transferUrl lastPathComponent];
            if ([fileName hasSuffix:@".gif"]&&(!self.playGif)) {
                transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
            }
            
            
            [weiboImage1 setBackgroundColor:[UIColor darkGrayColor]];
            [weiboImage1 setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
            
            
            CALayer *weiboImage = [weiboImage1 layer];   //获取ImageView的层
            [weiboImage setMasksToBounds:YES];
            [weiboImage setCornerRadius:0.0];
            
            
            weiboImage1.frame=frame;
             weiboImage1.contentMode = UIViewContentModeScaleAspectFill;
            
            if ([retweetPicsArray count]==1) {
                weiboImage1.contentMode = UIViewContentModeScaleAspectFill;
            }
            
            frame.origin.x = frame.origin.x +88;
            
            
            
            [self.retweetView addSubview:weiboImage1];
            
            
            if (i==2) {
                frame = self.retweetWeiboImage.frame;
                frame.origin.y = frame.origin.y+88;
                
                
            }
            if (i==5) {
                frame.origin.x =self.retweetWeiboImage.frame.origin.x;
                frame.origin.y = frame.origin.y+88;
            }
        }

        
        
        frame =self.retweetView.frame;
        
        if ([retweetPicsArray count] != 0) {
            
            int height = 0;
            self.retweetView.hidden=NO;
            //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
            if ([retweetPicsArray count]>6) {
                
                height = 88;
                //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            if ([retweetPicsArray count]>3) {
                height = height +88;
                // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            
            
            
            frame.size.height = self.retweetWeiboImage.frame.size.height + self.retweetWeiboImage.frame.origin.y+20.f+height;
            
            
            self.retweetView.frame= frame;
            
        }else{   /////////////转发的微博不带图片retweetView 的布局
            frame.size.height = self.retweetContent.frame.size.height + self.retweetContent.frame.origin.y+20.f;
           
            
            self.retweetView.frame= frame;
        }
        
        
    }
    
    /////////////////////////////转发内容布局、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
  
  
    
    
    
    
    
    
    frame = self.view.frame;
    if ([NSURL URLWithString: [self.rowData objectForKey:@"bmiddle_pic"]]==nil) {
        
        frame.size.height = self.content.frame.size.height + self.content.frame.origin.y+20.f;
        self.view.frame= frame;
        
        if ([self.rowData objectForKey:@"retweeted_status"]!=nil) {
            frame.size.height =self.retweetView.frame.size.height + self.retweetView.frame.origin.y+0.f;
            self.view.frame= frame;
            self.retweetView.hidden=NO;
        }else{
            self.retweetView.hidden=YES;
        }

    }else{
        
        int height = 0;
        self.retweetView.hidden=YES;
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
        int tagvalue = view.tag;
        int section = tagvalue/10000;
        int row = tagvalue- section*10000;
        NSString *url=[NSString new];
    
    
    if (section==0) {
        NSArray *picsArray =[self.rowData objectForKey:@"pic_urls"];
        NSArray * array = [[picsArray[row] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        //url = [self.rowData objectForKey:@"original_pic"];
        url=transferUrl;
        
    }else{
        NSDictionary *retweetRowData = [self.rowData objectForKey:@"retweeted_status"];

        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];
        
      
        NSArray * array = [[retweetPicsArray[row] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        
        url=transferUrl;
        
        
    }
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",url]];
    //  webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)retweetViewDetail:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    UIView *view = (UIView *)[gestureRecognizer view];
    
    
    NSDictionary *tempRowData=self.rowData;
    NSDictionary *rowData2 = [tempRowData objectForKey:@"retweeted_status"];
    NSString *weiboUserName = [[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    WeiboId =   [NSString stringWithFormat:@"%@",[rowData2 objectForKey:@"id"]];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeiboDetailAndCommentTableViewController *content1=[WeiboDetailAndCommentTableViewController new];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    content1=[storyboard instantiateViewControllerWithIdentifier:@"WeiboDetailAndCommentTableViewController"];
    
    NSLog(@"weiboid!!!!!%@",WeiboId);
    content1.navigationItem.title = weiboUserName;
    
    content1.weiboContent=[rowData2 objectForKey:@"text"];
    content1.weiboUserName=[[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    NSString *fileName = [[rowData2 objectForKey:@"thumbnail_pic"]  lastPathComponent];
    NSData *imageData = [NSData dataWithContentsOfFile: [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
    content1.weiboImagesData=imageData;
    content1.weiboUserUrl= [[rowData2 objectForKey:@"user"] objectForKey:@"profile_image_url"];
    // NSDictionary * rowData3 =WeiboContent[indexPath.row];
    content1.WeiboId =WeiboId;
    content1.weiboComments =WeiboContent;
    content1.original_pic =[rowData2 objectForKey:@"original_pic"];
    content1.rowData = rowData2;
    
    content1.hidesBottomBarWhenPushed = YES;
    
    
    
    [self.navigationController pushViewController:content1 animated:YES];
    
}
- (NSString *) getTimeString : (NSString *) string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDate *creatDate = [inputFormatter dateFromString:string];
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    //时间格式
    fmt=inputFormatter;
    if (creatDate.isThisYear) {//今年
        if (creatDate.isToday) {
            //获得微博发布的时间与当前时间的差距
            NSDateComponents *cmps=[creatDate deltaWithNow];
            if (cmps.hour>=1) {//至少是一个小时之前发布的
                return [NSString stringWithFormat:@"%d小时前",cmps.hour];
            }else if(cmps.minute>=1){//1~59分钟之前发布的
                return [NSString stringWithFormat:@"%d分钟前",cmps.minute];
            }else{//1分钟内发布的
                return @"刚刚";
            }
        }else if(creatDate.isYesterday){//昨天发的
            fmt.dateFormat=@"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        }else{//至少是前天发布的
            fmt.dateFormat=@"MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    }else           //  往年
    {
        fmt.dateFormat=@"yyyy-MM-dd";
        return [fmt stringFromDate:creatDate];
    }
    //
    //    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //    [outputFormatter setLocale:[NSLocale currentLocale]];
    //    [outputFormatter setDateFormat:@"HH:mm:ss"];
    //    NSString *str = [outputFormatter stringFromDate:inputDate];
    //
    //
    //    return str;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)[tap view];
    int tagvalue = abs(view.tag);
    int row = tagvalue/10000;
    int i = tagvalue - 10000*row-100;
    
    NSDictionary *rowData1 = self.rowData;
    
    NSString *url=[NSString new];
    
    
    if ([[rowData1 objectForKey:@"pic_urls"] count]!=0) {
        NSArray *picsArray =[rowData1 objectForKey:@"pic_urls"];
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        //url = [self.rowData objectForKey:@"original_pic"];
        url=transferUrl;
        
        
        int count = picsArray.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray new];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            
            NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
            //url = [self.rowData objectForKey:@"original_pic"];
            url=transferUrl;
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView =  (UIImageView *)[self.view viewWithTag:row+i+100];// 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        
        browser.photos = photos; // 设置所有的图片
        [browser show];
        
        
        
        
    }else{
        NSDictionary *retweetRowData = [rowData1 objectForKey:@"retweeted_status"];
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];
        
        
        NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        
        url=transferUrl;
        
        int count = retweetPicsArray.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片
            NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
            NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
            //url = [self.rowData objectForKey:@"original_pic"];
            url=transferUrl;
            
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:url]; // 图片路径
            photo.srcImageView =  (UIImageView *)[self.view viewWithTag:row*0+i+100]; // 来源于哪个UIImageView
            [photos addObject:photo];
            
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
        
        
        
        
    }
}

@end
