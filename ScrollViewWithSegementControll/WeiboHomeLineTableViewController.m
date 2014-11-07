//
//  WeiboHomeLineTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-17.
//  Copyright (c) 2014年 浩然. All rights reserved.
//
#import "PostWeiboViewController.h"
#import "WeiboHomeLineTableViewController.h"
#import "WeiboDetailAndCommentTableViewController.h"
#import "ScrollViewDetailViewController.h"
#import "UIButton+WebCache.h"
#import "WeiboPersonalDetailTableViewController.h"
@interface WeiboHomeLineTableViewController ()

@end

@implementation WeiboHomeLineTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
-(void)getUserName:(NSNotification*)notify
{
    // NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    [self homelineButtonPressed];
     [self userInfoButtonPressed];
    // self.userName.text =temp;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
     self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    
    
     [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getUnreadCountButtonPressed) userInfo:nil repeats:YES];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserName:)
												 name:@"getUserName" object:nil];
    loadingMore =NO ;
    UINib *nib = [UINib nibWithNibName:@"WeiboTableViewCell" bundle:nil];
   [self.tableView registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
    UINib *nib2 =[UINib nibWithNibName:@"WeiboWithoutImageTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"WeiboWithoutImageCell"];
    
    
    UINib *nib3 =[UINib nibWithNibName:@"WeiboAllInOneTableViewCell" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"WeiboAllInOneTableViewCell"];

    
    since_id = nil;
    SinaWeibo *sinaWeibo =[self sinaweibo];
    if (sinaWeibo.isAuthValid) {
        self.title=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    }
    
    
    [self setupRefresh];
    
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [tableviewlist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    rowData = tableviewlist[indexPath.row];
  
    
    WeiboAllInOneTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"WeiboAllInOneTableViewCell" forIndexPath:indexPath];
    
    NSString * userImageUrl =[[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSArray * array1 = [userImageUrl componentsSeparatedByString:@"/50/"];
    NSString *new = [NSString stringWithFormat:@"%@/180/%@",array1[0],array1[1]];
    
    
    
    UITapGestureRecognizer *nameSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapName:)];
    [cell.name addGestureRecognizer:nameSingleTap];
    
    [cell.userImage setImageWithURL:[NSURL URLWithString:new]];
    cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
    cell.time.text =[self getTimeString:[rowData objectForKey:@"created_at"]];
    cell.content.text = [rowData objectForKey:@"text"];
    NSString *from =[rowData objectForKey:@"source"];
    if (from.length>5) {
    NSArray * array = [from componentsSeparatedByString:@"\">"];
    NSString *temp = array[1];
    
        array = [temp componentsSeparatedByString:@"<"];
        from = array[0];
        cell.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
    }
   
    if ([from isEqualToString:@"知乎Plus"]|| [from isEqualToString:@"浩然的小尾巴"]) {
        cell.from.textColor=[UIColor orangeColor];
    }else{
        cell.from.textColor=[UIColor lightGrayColor];
    }
    
    
    CGRect orgRect=cell.content.frame;
    CGSize  size = [[rowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
    orgRect.size.height=size.height+20;
    cell.content.frame=orgRect;

    
    CGRect frame = [cell.weiboImages[0] frame];
    frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+10.f;
   
    
    
    
    
    NSArray *picsArray =[rowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
    int i =0;
    
    for (UIImageView *weiboImages in cell.weiboImages) {
        
        if (i<[picsArray count]) {
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [weiboImages addGestureRecognizer:singleTap];
            
            weiboImages.tag=100+indexPath.row*10000+i;
            
            
            weiboImages.frame=frame;
            weiboImages.clipsToBounds = YES;
            weiboImages.contentMode=UIViewContentModeScaleAspectFill;
            frame.origin.x = frame.origin.x +88;
            
            if (i==2) {
                frame = [cell.weiboImages[0] frame];
                frame.origin.y = frame.origin.y+88;
                
                
            }
            if (i==5) {
                CGRect temp = [cell.weiboImages[0] frame];
                frame.origin.x =temp.origin.x;
                frame.origin.y = frame.origin.y+88;
            }
     
            
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
            transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];

            NSString *fileName = [transferUrl lastPathComponent];
            if ([fileName hasSuffix:@".gif"]) {
                transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
            }
        [weiboImages setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
        i++;
            weiboImages.hidden=NO;
         }
        
        else
        {
            weiboImages.hidden=YES;
        }
    }
    
    /////////////////////////////转发内容布局、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
    
    if ([rowData objectForKey:@"retweeted_status"]!=nil) {
        
        NSDictionary *retweetRowData = [rowData objectForKey:@"retweeted_status"];
        cell.retweetView.hidden=NO;
        cell.retweetView.tag = indexPath.row;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetViewDetail:)];
        [cell.retweetView addGestureRecognizer:singleTap];
        UITapGestureRecognizer *nameSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapName:)];
        [cell.retweetName addGestureRecognizer:nameSingleTap];
        
        
        frame = cell.retweetView.frame;
        frame.origin.y =cell.content.frame.size.height + cell.content.frame.origin.y+10.f;
        cell.retweetView.frame = frame;
 
        cell.retweetName.text = [[retweetRowData objectForKey:@"user"] objectForKey:@"name"];
        cell.retweetTime.text =[self getTimeString:[retweetRowData objectForKey:@"created_at"]];
        cell.retweetContent.text=[retweetRowData objectForKey:@"text"];
        
        CGRect orgRect=cell.retweetContent.frame;
        CGSize  size = [[retweetRowData objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        orgRect.size.height=size.height+20;
        cell.retweetContent.frame=orgRect;
        
        size=[[[retweetRowData objectForKey:@"user"] objectForKey:@"name"] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
        frame = cell.retweetFrom.frame;
        frame.origin.x = size.width + cell.retweetName.frame.origin.x +10;
        cell.retweetFrom.frame= frame;
        
        NSString *retweetFrom =[retweetRowData objectForKey:@"source"];///////来源处理////////
        if (retweetFrom.length>5) {
            
            
        NSArray * retweetArray = [retweetFrom componentsSeparatedByString:@"\">"];
        NSString *retweetTemp = retweetArray[1];
        retweetArray = [retweetTemp componentsSeparatedByString:@"<"];
        retweetFrom = retweetArray[0];
        cell.retweetFrom.text =[NSString stringWithFormat:@"来自%@",retweetArray[0]];///////来源处理////////
        
        }
        if ([cell.from.text isEqualToString:@"来自知乎Plus"]||[cell.from.text isEqualToString:@"来自浩然的小尾巴"]) {
            cell.retweetFrom.textColor=[UIColor orangeColor];
        }else{
            cell.retweetFrom.textColor=[UIColor lightGrayColor];
        }
        
        
        
        
        CGRect frame = [cell.retweetWeiboImages[0] frame];
        frame.origin.y = cell.retweetContent.frame.size.height + cell.retweetContent.frame.origin.y+10.f;
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];/////// 多图地址、、、、、、、、、
        

        
        for (UIImageView *weiboImages in cell.retweetWeiboImages) {
            
            if (i<[retweetPicsArray count]) {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [weiboImages addGestureRecognizer:singleTap];
                
                weiboImages.tag=100+indexPath.row*10000+i;
                
                
                
                
                weiboImages.frame=frame;
                 weiboImages.clipsToBounds = YES;
                weiboImages.contentMode=UIViewContentModeScaleAspectFill;
                frame.origin.x = frame.origin.x +88;
                
                if (i==2) {
                    frame = [cell.retweetWeiboImages[0] frame];
                    frame.origin.y = frame.origin.y+88;
                    
                    
                }
                if (i==5) {
                    CGRect temp = [cell.retweetWeiboImages[0] frame];
                    frame.origin.x =temp.origin.x;
                    frame.origin.y = frame.origin.y+88;
                }
                
                
                NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
                NSString *transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
                transferUrl =[NSString stringWithFormat:@"%@bmiddle%@",array[0],array[1]];
                NSString *fileName = [transferUrl lastPathComponent];
                if ([fileName hasSuffix:@".gif"]) {
                    transferUrl =[NSString stringWithFormat:@"%@thumbnail%@",array[0],array[1]];
                }
                [weiboImages setImageURLStr:transferUrl placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                i++;
                weiboImages.hidden=NO;
            }
            
            else
            {
                weiboImages.hidden=YES;
            }
        }
        
        
        frame =cell.retweetView.frame;
        
        if ([retweetPicsArray count] != 0) {
            
            int height = 0;
            cell.retweetView.hidden=NO;
            //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
            if ([retweetPicsArray count]>6) {
                
                height = 88;
                //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            if ([retweetPicsArray count]>3) {
                height = height +88;
                // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
            }
            
            CGRect temp = [cell.retweetWeiboImages[0] frame];
            
            frame.size.height = temp.size.height + temp.origin.y+20.f+height;
            
            
            cell.retweetView.frame= frame;
            
        }
        else{   /////////////转发的微博不带图片retweetView 的布局
            frame.size.height = cell.retweetContent.frame.size.height + cell.retweetContent.frame.origin.y+20.f;
            
            
            cell.retweetView.frame= frame;
            
        }
        
       // frame =cell.gap.frame;
       // frame.origin.y = cell.retweetView.frame.origin.y+cell.retweetView.frame.size.height;
       // cell.gap.frame=frame;
    }
    
    
    
    
    frame = cell.content.frame;
    if ([NSURL URLWithString: [rowData objectForKey:@"bmiddle_pic"]]==nil) {
        
        frame.size.height = cell.content.frame.size.height + cell.content.frame.origin.y+20.f+30;
        cell.contentView.frame= frame;
        
        frame = cell.retweetButton.frame;
        frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.retweetButton.frame = frame;
        
        frame = cell.reviewButton.frame;
        frame.origin.y = cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.reviewButton.frame = frame;
        
        frame = cell.zhanButton.frame;
        frame.origin.y =  cell.content.frame.size.height + cell.content.frame.origin.y+20.f;
        cell.zhanButton.frame = frame;
        
        if ([rowData objectForKey:@"retweeted_status"]!=nil) {
            frame.size.height =cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y+0.f+30;
            cell.contentView.frame= frame;
            
            frame = cell.retweetButton.frame;
            frame.origin.y = cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.retweetButton.frame = frame;
            
            frame = cell.reviewButton.frame;
            frame.origin.y = cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.reviewButton.frame = frame;
            
            frame = cell.zhanButton.frame;
            frame.origin.y =  cell.retweetView.frame.size.height + cell.retweetView.frame.origin.y;
            cell.zhanButton.frame = frame;
            
            cell.retweetView.hidden=NO;
        }else{
            cell.retweetView.hidden=YES;
        }
        
    }else{
        
        int height = 0;
        cell.retweetView.hidden=YES;
        //  frame.size.height = self.weiboImage.frame.size.height + self.weiboImage.frame.origin.y+20.f;
        if ([picsArray count]>6) {
            
            height = 88;
            //  frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        if ([picsArray count]>3) {
            height = height +88;
            // frame.size.height = self.weiboImage.frame.origin.y+ self.weiboImage.frame.size.height +88 ;
        }
        
        
        CGRect temp = [cell.weiboImages[0] frame];
        frame.size.height = temp.size.height + temp.origin.y+20.f+height+30;
        
        frame = cell.retweetButton.frame;
        frame.origin.y =  temp.size.height + temp.origin.y+20.f+height;
        cell.retweetButton.frame = frame;
        
        frame = cell.reviewButton.frame;
        frame.origin.y = temp.size.height + temp.origin.y+20.f+height;
        cell.reviewButton.frame = frame;
        
        frame = cell.zhanButton.frame;
        frame.origin.y =  temp.size.height + temp.origin.y+20.f+height;
        cell.zhanButton.frame = frame;
        cell.contentView.frame= frame;
        
        
    }

    
    return  cell;
    
//    static NSString * cellID=@"cellID";
//    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    
//    if(cell==nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];    }
//    for (UIView *subview in [cell.contentView subviews])
//        
//    {
//        
//        [subview removeFromSuperview];
//        
//    }
//    
//    WeiboDetailViewController *view=[WeiboDetailViewController new];
//    view.rowData =rowData;
//    view.playGif =NO;
//    
//    
//    [cell.contentView addSubview:view.view];
//    view.view.frame = cell.contentView.bounds;
//    
//    [self addChildViewController:view];
//    return cell;
//
//    if (indexPath.row %2 == 0) {
//        view.view.backgroundColor = [UIColor greenColor];
//    } else
//        view.view.backgroundColor = [UIColor blueColor];
//    
   
//    cell.backgroundColor=[UIColor yellowColor];
//    
//
   
//    CGRect orgRect=cell.content.frame;
//
//    if ( [tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
//        
//     
//        NSString *desContent =[rowData objectForKey:@"text"];
//    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
//    
////    CGSize  size = [desContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
////    orgRect.size.height=size.height+20;
////    cell.content.frame=orgRect;
////
//    
////    CGSize size = CGSizeMake(320,2000);
////    //计算实际frame大小，并将label的frame变成实际大小
////    CGSize labelsize = [desContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
////    //[cell.content setFrame:CGRectMake:(0,0, labelsize.width, labelsize.height)];
////    orgRect.size.height=size.height+20;
////    cell.content.frame=orgRect;
//  
//    /*
//     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
//     */
//   
//        NSString *from =[rowData objectForKey:@"source"];
//        NSArray * array = [from componentsSeparatedByString:@"\">"];
//
//        NSString *temp = array[1];
//        array = [temp componentsSeparatedByString:@"<"];
//        from = array[0];
//    cell.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
//        if ([from isEqualToString:@"知乎Plus"]) {
//               cell.from.textColor=[UIColor orangeColor];
//        }else{
//            cell.from.textColor=[UIColor lightGrayColor];
//        }
//        
//    cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
//    cell.time.text =  [rowData objectForKey:@"created_at"];
//    cell.content.text = desContent;
//    
//    if ( [tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
//        
//    //    UIImageView *temp =[UIImageView new];
//        //[temp setImageWithURL: [NSURL URLWithString: [rowData objectForKey:@"bmiddle_pic"]]];
//        //[cell.weiboImage setImage: temp.image forState:UIControlStateNormal];
//        
//        [cell.weiboImage setImageWithURL:[tableviewlist[indexPath.row] objectForKey:@"bmiddle_pic"]];
//        cell.weiboImage.hidden = NO;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yourHandlingCode:)];
//        [cell.weiboImage addGestureRecognizer:singleTap];
//          cell.weiboImage.tag=indexPath.section*10000+indexPath.row;///// 设置 star的tag
//    }
////    
////    else{
////        CGRect orgRect=cell.weiboImage.frame;
////        
////        orgRect.size.height =0;
////        orgRect.origin.y = cell.content.frame.size.height-5;
////        cell.weiboImage.frame= orgRect;
////       // cell.weiboImage.hidden = YES;
////    }
////           
////    
//    
//    NSString *userurl= [[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];////设置cell中的头像
//
//    [cell.userImage setImageWithURL:[NSURL URLWithString:userurl]
//                   placeholderImage:[UIImage imageNamed:@"Expression_2"]];
//    
//    
//    
//
//    return cell;
//        
//        
//    }
//    else
//    {
//        
//        
//            WeiboWithoutImageTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WeiboWithoutImageCell" forIndexPath:indexPath];
//        
//        NSString *from =[rowData objectForKey:@"source"];
//        NSArray * array = [from componentsSeparatedByString:@"\">"];
//        
//        NSString *temp = array[1];
//        array = [temp componentsSeparatedByString:@"<"];
//        from = array[0];
//        cell.from.text =[NSString stringWithFormat:@"来自%@",from];///////来源处理////////
//        if ([from isEqualToString:@"知乎Plus"]) {
//            cell.from.textColor=[UIColor orangeColor];
//        }else{
//            cell.from.textColor=[UIColor lightGrayColor];
//        }
//        
//            cell.name.text = [[rowData objectForKey:@"user"] objectForKey:@"name"];
//            cell.time.text =  [rowData objectForKey:@"created_at"];
//            NSString *desContent =[rowData objectForKey:@"text"];
//            cell.content.text = desContent;
//            NSString *userurl= [[rowData objectForKey:@"user"] objectForKey:@"profile_image_url"];////设置cell中的头像
//            [cell.userImage setImageWithURL:[NSURL URLWithString:userurl]
//                       placeholderImage:[UIImage imageNamed:@"Expression_2"]];
//        
//           if ( [rowData objectForKey:@"retweeted_status"]!= nil) {  /////显示转发微博
//     
//           }
//        return cell;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
 //   WeiboTableViewCell *cell = (WeiboTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *rowData1 = tableviewlist[indexPath.row];
//    NSString *content = [tableviewlist[indexPath.row]  objectForKey:@"text"];
//    // 計算出顯示完內容需要的最小尺寸
//      CGSize  size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
//    
//   
//    if ([tableviewlist[indexPath.row] objectForKey:@"thumbnail_pic"] != nil) {
//         return size.height+100+100;
//    }
//    
//    return size.height+140;
//    //cell.content.frame.size.height+cell.userImage.frame.size.height;
//    
    WeiboDetailViewController *view=[WeiboDetailViewController new];
    view.rowData =rowData1;
    
    return view.view.frame.size.height+30;
   }


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"postWeibo"])
    {
//        PostWeiboViewController *view = [segue destinationViewController];
//    
//    
//        view.hidesBottomBarWhenPushed = YES;
//    
    }

    
    
    
}


///////////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新,不客气_(:з」∠)_";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @" - ( ゜- ゜)つロ 乾杯~ ";
}

#pragma mark 开始进入刷新状态

- (void)headerRereshing
{
    // 1.添加假数据
    //   for (int i = 0; i<5; i++) {
    //       [self.fakeData insertObject:MJRandomData atIndex:0];
    //  }
  //  [self getData];
    // 2.2秒后刷新表格UI
   
    
        // 刷新表格
       // [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SinaWeibo *sinaWeibo = [self sinaweibo];
            if (!sinaWeibo.isAuthValid) {
                UIAlertView *alert = [UIAlertView new];
                
                alert = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:@"还没有登陆微博呢！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                // [alert show];
                [self.tableView headerEndRefreshing];
                [sinaWeibo logIn];//两秒后返回上一页 ~~~~~~~~~
            }
             [self homelineButtonPressed];
            
        });
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
      //  [self.tableView headerEndRefreshing];
   
}

- (void)footerRereshing
{
    //    // 1.添加假数据
    //   // for (int i = 0; i<5; i++) {
    //  //      [self.fakeData addObject:MJRandomData];
    // //   }
    //
   // [self getOneDayData];
    //
    
    
    
    
    //////  上拉加载更多
    
    
    
    
    //    // 2.2秒后刷新表格UI
   // [self homelineButtonPressed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             SinaWeibo *sinaWeibo = [self sinaweibo];
            if (!sinaWeibo.isAuthValid) {
                UIAlertView *alert = [UIAlertView new];
                
                alert = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:@"还没有登陆微博呢！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                [self.tableView footerEndRefreshing];
            }
            loadingMore = YES;
            [self homelineWithPageButtonPressed];
    //        // 刷新表格
    //        [self.tableView reloadData];
    //
            
    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//          [self.tableView footerEndRefreshing];
    });
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
    //    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"https://rm.api.weibo.com/2/remind/unread_count.json"])
    {
        
        read = result;
     //   NSLog(@"request%@",read);
        [[[[[self tabBarController] viewControllers] objectAtIndex: 0] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%@",[read objectForKey:@"status"]]];
      
       
    }
    //    PullTableView *tableView =(id)[self.view viewWithTag:1];
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = result;
               NSMutableArray *temp =[NSMutableArray new];
        [temp addObject:userInfo];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"screen_name"] forKey:[NSString stringWithFormat:@"userName"]];
        self.title =[userInfo objectForKey:@"screen_name"];
        NSString * i =[userInfo objectForKey:@"profile_image_url"] ;
        NSArray * array = [i componentsSeparatedByString:@"/50/"];
        NSString *new = [NSString stringWithFormat:@"%@/180/%@",array[0],array[1]];
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"avatar_large"] forKey:[NSString stringWithFormat:@"profile_image_url"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
       
        // [self userInfoButtonPressed];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = [result objectForKey:@"statuses"];
    }
    else if ([request.url hasSuffix:@"statuses/home_timeline.json"])
    {
        NSLog(@"3");
        homeline = [result objectForKey:@"statuses"];
        
        
        //  tableviewlist =[[NSMutableArray alloc] init];
        if ([homeline count]!= 0)
        {
            if (loadingMore)
            {
                NSMutableArray *temp = [homeline mutableCopy];
                [temp removeObjectAtIndex:0];
                tableviewlist = [[tableviewlist arrayByAddingObjectsFromArray:temp] mutableCopy];
                NSLog(@"222222%lu",(unsigned long)[tableviewlist count]);
                loadingMore = NO;
            }
            else{
            
            
            tableviewlist = [[homeline arrayByAddingObjectsFromArray:tableviewlist] mutableCopy];
            NSLog(@" %d %@",[homeline count],[[homeline objectAtIndex:0] objectForKey:@"id"]);
            NSString *ValueString =[NSString stringWithFormat:@"%@",[[homeline objectAtIndex:0] objectForKey:@"id"]];
            since_id = ValueString;
            [self getUnreadCountButtonPressed];////获取角标、、、、、、、、
                }
        }
        
        
        
        
        
      
        
        // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
        //   [[NSUserDefaults standardUserDefaults] synchronize];
        // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
        //  [viewData setObject:rowData forKey:@"rowData"];
        // [viewData synchronize];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        
    }
    else if ([request.url hasSuffix:@"comments/show.json"])
    {   //PullTableView *tableView2=(id)[self.view viewWithTag:2];
        //NSLog(@"3");
        WeiboContent = [result objectForKey:@"comments"];
        
     //   NSLog(@" 1111111%@",[[[homeline objectAtIndex:0] objectForKey:@"user"]  objectForKey:@"name"]);
   //     NSLog(@"WeiboContent%@",WeiboContent);
        
        //[tableView2 reloadData];
        
        
        // [[NSUserDefaults standardUserDefaults] setObject:homeline forKey:@"homeline"];
        //   [[NSUserDefaults standardUserDefaults] synchronize];
        // NSUserDefaults *viewData =[NSUserDefaults standardUserDefaults];
        //  [viewData setObject:rowData forKey:@"rowData"];
        // [viewData synchronize];
        // [tableView reloadData];
        //NSLog(@"%@",WeiboContent);
        isflage = YES;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
     //   [alertView show];
        
        postStatusText = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
       // [alertView show];
        
        postImageStatusText = nil;isPic = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"access token result = %@", result);
        
        // [self logInDidFinishWithAuthInfo:result];
        
    }
   
    // [self resetButtons];
}


#pragma mark - SinaWeibo各种请求

- (void)userInfoButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}


- (void)homelineButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:since_id,@"since_id",nil];
    Requst=[sinaweibo requestWithURL:@"statuses/home_timeline.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    for (NSString *show in param) {
        NSLog(@"显示%@",show);
    }
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}
- (void)homelineWithPageButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    NSString *ValueString =[NSString stringWithFormat:@"%@",[[tableviewlist objectAtIndex:[tableviewlist count]-1] objectForKey:@"id"]];
    max_id = ValueString;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:max_id,@"max_id",nil];
    Requst=[sinaweibo requestWithURL:@"statuses/home_timeline.json"
                              params:param
                          httpMethod:@"GET"
                            delegate:self];
    for (NSString *show in param) {
        NSLog(@"显示%@",show);
    }
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}
- (void)getUnreadCountButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:sinaweibo.accessToken forKey:@"access_token"];
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"https://rm.api.weibo.com/2/remind/unread_count.json"
                                                       httpMethod:@"GET"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid",sinaweibo.accessToken,@"access_token" ,nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
   }
- (void)getWeiboContent
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    SinaWeiboRequest *Requst;
    Requst=[sinaweibo requestWithURL:@"comments/show.json"
                              params:[NSMutableDictionary dictionaryWithObject:WeiboId forKey:@"id"]
                          httpMethod:@"GET"
                            delegate:self];
    
    
    //NSLog(@"显示%@",[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]);
    
}static int post_status_times = 0;
- (void)postStatusButtonPressed
{
    if (!postStatusText)
    {
        post_status_times ++;
        postStatusText = nil;
        //      postStatusText = [[NSString alloc] initWithFormat:@"%@",self.testField.text];
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    [alertView show];
}

static int post_image_status_times = 0;
- (void)postImageStatusButtonPressed
{
    if (!postImageStatusText)
    {
        post_image_status_times ++;
        postImageStatusText = nil;
        
        //  postImageStatusText = [[NSString alloc] initWithFormat:@"%@",self.testField.text];
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post image status with text \"%@\"", postImageStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:postStatusText, @"status", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
        else if (alertView.tag == 1)
        {
            //            // post image status
            //            SinaWeibo *sinaweibo = [self sinaweibo];
            //
            //            [sinaweibo requestWithURL:@"statuses/upload.json"
            //                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
            //                                       postImageStatusText, @"status",
            //                                       self.imageView.image, @"pic", nil]
            //                           httpMethod:@"POST"
            //                             delegate:self];
            
        }
    }
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowData2 =tableviewlist[indexPath.row];
    NSString *weiboUserName = [[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    WeiboId =   [NSString stringWithFormat:@"%@",[rowData2 objectForKey:@"id"]];
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeiboDetailAndCommentTableViewController *content =  [self.storyboard instantiateViewControllerWithIdentifier:@"WeiboDetailAndCommentTableViewController"];
    
     NSLog(@"weiboid!!!!!%@",WeiboId);
      content.navigationItem.title = weiboUserName;
    
    content.weiboContent=[rowData2 objectForKey:@"text"];
    content.weiboUserName=[[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    NSString *fileName = [[rowData2 objectForKey:@"thumbnail_pic"]  lastPathComponent];
    NSData *imageData = [NSData dataWithContentsOfFile: [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
    content.weiboImagesData=imageData;
    content.weiboUserUrl= [[rowData2 objectForKey:@"user"] objectForKey:@"profile_image_url"];
    // NSDictionary * rowData3 =WeiboContent[indexPath.row];
    content.WeiboId =WeiboId;
    content.weiboComments =WeiboContent;
    content.original_pic =[rowData2 objectForKey:@"original_pic"];
    content.rowData = rowData2;
    
    content.hidesBottomBarWhenPushed = YES;
    
    
    
    [self.navigationController pushViewController:content animated:YES];
    
    
    
    
    
}

-(void)yourHandlingCode:(UIGestureRecognizer *)gestureRecognizer
{
    
  
    UIImageView *view = (UIImageView *)[gestureRecognizer view];
    int tagvalue = abs(view.tag);
    int row = tagvalue/10000;
    int i = tagvalue - 10000*row-100;
    NSString *url=[NSString new];
    
    NSDictionary *rowData1 = tableviewlist[row];
    
    if ([[rowData1 objectForKey:@"pic_urls"] count]!=0) {
        NSArray *picsArray =[rowData1 objectForKey:@"pic_urls"];
        NSArray * array = [[picsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        //url = [self.rowData objectForKey:@"original_pic"];
        url=transferUrl;
        
    }else{
        NSDictionary *retweetRowData = [rowData1 objectForKey:@"retweeted_status"];
        
        NSArray *retweetPicsArray =[retweetRowData objectForKey:@"pic_urls"];
        
        
        NSArray * array = [[retweetPicsArray[i] valueForKey:@"thumbnail_pic"] componentsSeparatedByString:@"thumbnail"];
        NSString *transferUrl =[NSString stringWithFormat:@"%@large%@",array[0],array[1]];
        
        url=transferUrl;
        
        
    }
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",url]];
    //  webViewController.hidesBottomBarWhenPushed = YES;
    
    webViewController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)retweetViewDetail:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    UIImageView *view = (UIImageView *)[gestureRecognizer view];
    
    
    NSDictionary *tempRowData=tableviewlist[view.tag];
    NSDictionary *rowData2 = [tempRowData objectForKey:@"retweeted_status"];
    NSString *weiboUserName = [[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    WeiboId =   [NSString stringWithFormat:@"%@",[rowData2 objectForKey:@"id"]];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeiboDetailAndCommentTableViewController *content =  [self.storyboard instantiateViewControllerWithIdentifier:@"WeiboDetailAndCommentTableViewController"];
    
    NSLog(@"weiboid!!!!!%@",WeiboId);
    content.navigationItem.title = weiboUserName;
    
    content.weiboContent=[rowData2 objectForKey:@"text"];
    content.weiboUserName=[[rowData2 objectForKey:@"user"] objectForKey:@"name"];
    NSString *fileName = [[rowData2 objectForKey:@"thumbnail_pic"]  lastPathComponent];
    NSData *imageData = [NSData dataWithContentsOfFile: [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
    content.weiboImagesData=imageData;
    content.weiboUserUrl= [[rowData2 objectForKey:@"user"] objectForKey:@"profile_image_url"];
    // NSDictionary * rowData3 =WeiboContent[indexPath.row];
    content.WeiboId =WeiboId;
    content.weiboComments =WeiboContent;
    content.original_pic =[rowData2 objectForKey:@"original_pic"];
    content.rowData = rowData2;
    
    content.hidesBottomBarWhenPushed = YES;
    
    
    
    [self.navigationController pushViewController:content animated:YES];

}

- (NSString *) getTimeString : (NSString *) string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    //NSDate* inputDate = [inputFormatter dateFromString:string];
   
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
    
   NSDictionary *rowData1 = tableviewlist[row];
    
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
            photo.srcImageView = (UIImageView *)[self.view viewWithTag:row*10000+i+100];// 来源于哪个UIImageView
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
            photo.srcImageView =  (UIImageView *)[self.view viewWithTag:row*10000+i+100];  // 来源于哪个UIImageView
            [photos addObject:photo];
        
    }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
       
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
        
        
    
    
  }
}

- (void)tapName:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)[tap view];
    NSString *screenName = label.text;
    
    NSLog(@"点击的名字为：%@",screenName);
    
    WeiboPersonalDetailTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiboPersonalDetailTableViewController"];
    viewController.screenName = screenName;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
