//
//  CCTVGeneralThreadTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "CCTVGeneralThreadTableViewController.h"
#import "MJPhotoBrowser.h"
#import "CCTVfirstTableViewCell.h"
#import "generalThreadTableViewCell.h"
@interface CCTVGeneralThreadTableViewController ()

@end

@implementation CCTVGeneralThreadTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.rowData objectForKey:@"name"];
    UINib *nib = [UINib nibWithNibName:@"generalThreadTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"generalThreadTableViewCell"];

    [self downLoadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)downLoadData
{
    
    NSString *thread_id = [self.rowData objectForKey:@"thread_id"];
    NSString *forum_id = [self.rowData objectForKey:@"forum_id"];
    
    
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://192.168.1.35/cctvapi/thread/general"
                                                       httpMethod:@"POST"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:thread_id,@"thread_id",forum_id,@"forum_id",@"1",@"sort",@"0",@"offset",@"1",@"type",nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
    
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    receivedData = result ;
    
 //   NSLog(@"%@",receivedData);
    
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 富文本处理

- (void)richTextView:(TQRichTextView *)view touchBeginRun:(TQRichTextRun *)run
{
    
}

- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextRun *)run
{
    if ([run isKindOfClass:[TQRichTextRunURL class]])
    {
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.text]];
        
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",run.text]];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
        
    }
    
    
    NSLog(@"%@",run.text);
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@",[url absoluteString]]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];

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
    
    
    NSArray *countRows = [receivedData objectForKey:@"items"];
    
    int i = countRows.count+1;
    return i;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
   
    // Configure the cell...
    if (indexPath.row == 0) {
        
        
        CCTVfirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CCTVfirstTableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:@"firstCell"];
        } //若返回的是nil，即cell==nil，则我们需要分配空间并初始化一个cell，而且需 要关联reuseIdentifier，以便后面重用的时候能够根据Identifier找到这个cell，若cell不为nil，则重用成功，并可 return此cell。
       
           for (UIView *subview in [cell.contentView subviews])
        
            {
        
                [subview removeFromSuperview];
                
            }
        
        
        NSDictionary *subject = [receivedData objectForKey:@"subject"];
        NSArray *content = [subject objectForKey:@"content"];
        
        
        UILabel *floor =[UILabel new];
        floor.font = [UIFont systemFontOfSize:12];
        floor.frame= CGRectMake(295, 5, 21, 21);
        floor.textColor = [UIColor lightGrayColor];
        floor.text = @"1楼";
        [cell.contentView addSubview:floor];
        
        
        
        CGRect frame = cell.contentView.frame;
        frame.origin.y = 20;
        frame.origin.x = 20;
        int i =0;
        for (NSDictionary *eachContent in content) {
            
            
            
            NSString *type = [NSString stringWithFormat:@"%@",[eachContent objectForKey:@"type"]];
            if ([type isEqualToString:@"1"])
            {
                
                UILabel *text = [UILabel new];
                text.text = [eachContent objectForKey:@"text"];
                text.font = [UIFont systemFontOfSize:15];
                 CGSize  size = [[eachContent objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:UILineBreakModeWordWrap];
                frame.size = size;
                text.frame = frame;
                text.numberOfLines = 0;
//              text.textColor = [UIColor redColor];
//              CGRect  rect = [TQRichTextView boundingRectWithSize:CGSizeMake(280, 5000)
//                                                             font:[UIFont systemFontOfSize:15]
//                                                           string:[NSString stringWithFormat:@"%@",[eachContent objectForKey:@"text"]]
//                                                        lineSpace:1.0f];
//                frame.size =rect.size;
//              //  NSLog(@"%@",NSStringFromCGRect(rect));
//                
//                TQRichTextView *textView = [TQRichTextView new];
//                textView.text = [NSString stringWithFormat:@"%@",[eachContent objectForKey:@"text"]];
//                textView.lineSpace = 1.0f;
//                textView.font = [UIFont systemFontOfSize:15.0f];
//                textView.backgroundColor = [UIColor clearColor];
//                textView.delegage = self;
//                frame.size =rect.size;
//                textView.frame =frame;
//                textView.textColor = [UIColor darkTextColor];
//                textView.backgroundColor = [UIColor yellowColor];
//                [cell.contentView addSubview:textView];
                [cell.contentView addSubview:text];
                
            }else
            {
                UIImageView *imageView = [UIImageView new];
                [imageView setImageURLStr:[eachContent objectForKey:@"text"] placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                NSArray * array = [[eachContent objectForKey:@"text"] componentsSeparatedByString:@"?"];
                
                
                if (array.count>1) {
                    NSString *size = array[1];
                    NSArray * array = [size componentsSeparatedByString:@"="];
                    array = [array[1] componentsSeparatedByString:@"x"];
                    NSString *height =array[1];
                    NSString *width = array[0];
                    
                    
                    
                    frame.size.height = [height doubleValue]*280/[width doubleValue];
                    frame.size.width = 280;
                }
                else{
                frame.size.height = 50;
                frame.size.width = 50;
                }
                imageView.frame = frame;
                  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:singleTap];
                
                
                imageView.tag = indexPath.row*10000+ i + 100;
                i++;
                
                
               [cell.contentView addSubview:imageView];
                
            }
            
            frame.origin.y = frame.origin.y + frame.size.height+5;
            
        }
        NSString *temp = [NSString stringWithFormat:@"%f",frame.size.height];
        [storeHeight setObject:temp forKey:[NSString stringWithFormat:@"%d",indexPath.row]];

        return cell;
    }
    
    else
    {
        generalThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalThreadTableViewCell" forIndexPath:indexPath];
        
        NSArray *countRows = [receivedData objectForKey:@"items"];
        NSDictionary *rowData = countRows[indexPath.row-1];
        
        NSDictionary *content = [rowData objectForKey:@"content"];
        cell.name.text = [rowData objectForKey:@"name"];
        cell.content.text = [content objectForKey:@"text"];
        cell.time.text = [rowData objectForKey:@"time"];
        cell.floor.text = [NSString stringWithFormat:@"%@楼",[rowData objectForKey:@"floor"]];
        NSArray *pic = [content objectForKey:@"pic"];
        
        CGRect frame = cell.content.frame;
        CGSize  size = [[content objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(247, 2000) lineBreakMode:UILineBreakModeWordWrap];
        frame.size=size;
        cell.content.frame=frame;
        cell.content.delegate= self;
        cell.content.userInteractionEnabled = YES;
        
        cell.content.activeLinkAttributes =[ NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(__bridge NSString *)kCTUnderlineStyleAttributeName];
        cell.content.enabledTextCheckingTypes = NSTextCheckingAllTypes;
            
        
            int i = 0;
            for (UIImageView *temp in cell.images) {
                
                 if (i<[pic count])
                 {
                     if ([pic[i]isKindOfClass:[NSDictionary class]])
                     {
                         NSString *url =[pic[i] objectForKey:@"pic"];

                     
                     temp.tag = indexPath.row*10000+ i + 100;

                     i++;
                         if ([url hasPrefix:@"http"])
                        {
                        
                        ////////设置图片位置
                        
                        NSArray * array = [url componentsSeparatedByString:@"?"];
                        frame.origin.y = frame.origin.y + frame.size.height + 10;
                        
                        if (array.count>1)
                        {
                            NSString *size = array[1];
                            NSArray * array = [size componentsSeparatedByString:@"="];
                            array = [array[1] componentsSeparatedByString:@"x"];
                            NSString *height =array[1];
                            NSString *width = array[0];
                            
                            
                            
                            frame.size.height = [height doubleValue]*247/[width doubleValue];
                            frame.size.width = 247;
                        }
                        
                        
                        temp.frame = frame;
                        
                        
                        [temp setImageURLStr:url
                                 placeholder:[UIImage imageNamed:@"timeline_image_loading.png"]];
                        temp.hidden = NO;
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                        temp.userInteractionEnabled = YES;
                        [temp addGestureRecognizer:singleTap];
                        }
                    }
                }
                else
                {
                    temp.hidden = YES;
                }
            
            
        
         }
        
        
     return cell;
    }
   

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //some functions
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    // 取消选中状态
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row==0)
    {
        NSDictionary *subject = [receivedData objectForKey:@"subject"];
        NSArray *content = [subject objectForKey:@"content"];
        
        
        return  [self countHeightForCell:content]+20;
    }
    else{
        NSArray *countRows = [receivedData objectForKey:@"items"];
        NSDictionary *rowData = countRows[indexPath.row-1];
        NSDictionary *content = [rowData objectForKey:@"content"];
        CGRect frame = CGRectMake(53, 42, 247, 18);
        CGSize  size = [[content objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(247, 2000) lineBreakMode:UILineBreakModeWordWrap];
        frame.size=size;
        
        
        NSArray *pic = [NSArray new];
        if ([[content objectForKey:@"pic"]isKindOfClass:[NSArray class] ]) {
            pic = [content objectForKey:@"pic"];
        }
            for (int i = 0;i<[pic count];i++)
            {
                
                if ([pic[i] isKindOfClass:[NSDictionary class]])
                {
                    
                
                NSString *url =[pic[i] objectForKey:@"pic"];
                
                    ////////设置图片位置
                    
                    NSArray * array = [url componentsSeparatedByString:@"?"];
                    frame.origin.y = frame.origin.y + frame.size.height + 10;
                    
                    if (array.count>1)
                    {
                        NSString *size = array[1];
                        NSArray * array = [size componentsSeparatedByString:@"="];
                        array = [array[1] componentsSeparatedByString:@"x"];
                        NSString *height =array[1];
                        NSString *width = array[0];
                        
                        
                        
                        frame.size.height = [height doubleValue]*247/[width doubleValue];
                        frame.size.width = 247;
                    }
                }
            }

        
        return frame.size.height + frame.origin.y +10;
    }
    
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)[tap view];
    
    
    
    int tagvalue = abs(view.tag);
    int row = tagvalue/10000;
    int i = tagvalue - 10000*row -100;
    
    NSDictionary *subject = [receivedData objectForKey:@"subject"];
    NSArray *content = [subject objectForKey:@"content"];
    
        // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray new];
    
            // 替换为中等尺寸图片
            
    int tag = 0;
    if (row == 0)
    {
        for (NSDictionary *eachContent in content)
        {
          
            NSString *type = [NSString stringWithFormat:@"%@",[eachContent objectForKey:@"type"]];
            
            if ([type isEqualToString:@"2"])
            {
                //url = [self.rowData objectForKey:@"original_pic"];
                
                MJPhoto *photo = [[MJPhoto alloc] init];
                // photo.url = [NSURL URLWithString:[eachContent objectForKey:@"text"]]; // 图片路径
                photo.image = [(UIImageView*)[self.view viewWithTag:row*10000+tag+100] image];
                photo.srcImageView = (UIImageView*)[self.view viewWithTag:row*10000+tag+100];// 来源于哪个UIImageView
                tag++;
                [photos addObject:photo];
                
                
            }
            
        }
    }
   else
   {
       
       NSArray *countRows = [receivedData objectForKey:@"items"];
       NSDictionary *rowData = countRows[row-1];
       NSDictionary *content = [rowData objectForKey:@"content"];
       NSArray *pic = [content objectForKey:@"pic"];
       
       for (int tag = 0; tag<[pic count]; tag++)
       {
           
           MJPhoto *photo = [[MJPhoto alloc] init];
           // photo.url = [NSURL URLWithString:[eachContent objectForKey:@"text"]]; // 图片路径
           photo.image = [(UIImageView*)[self.view viewWithTag:row*10000+tag+100] image];
           photo.srcImageView = (UIImageView*)[self.view viewWithTag:row*10000+tag+100];// 来源于哪个UIImageView
           [photos addObject:photo];
       }
       
       
       
       
   }
    
    
    
    
    
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = i; // 弹出相册时显示的第一张图片是？
        
        browser.photos = photos; // 设置所有的图片
        [browser show];
    
        
}



#pragma mark - 处理cell高度
-(float)countHeightForCell:(NSArray *)content
{
    
    CGRect frame;
    frame.origin.y = 20;
    frame.origin.x = 20;
    
    for (NSDictionary *eachContent in content) {
        
        NSString *type = [NSString stringWithFormat:@"%@",[eachContent objectForKey:@"type"]];
        if ([type isEqualToString:@"1"])
        {
            
        CGSize  size = [[eachContent objectForKey:@"text"]sizeWithFont:[UIFont systemFontOfSize:15]
                                                     constrainedToSize:CGSizeMake(280, 2000)
                                                         lineBreakMode:UILineBreakModeWordWrap];
            
            
          CGRect   rect = [TQRichTextView boundingRectWithSize:CGSizeMake(280, 5000) font:[UIFont systemFontOfSize:15] string:[eachContent objectForKey:@"text"] lineSpace:1.0f];
          
            frame.size =size;
        }else
        {
            NSArray * array = [[eachContent objectForKey:@"text"] componentsSeparatedByString:@"?"];
            
            
            if (array.count>1) {
                NSString *size = array[1];
                NSArray * array = [size componentsSeparatedByString:@"="];
                array = [array[1] componentsSeparatedByString:@"x"];
                NSString *height =array[1];
                NSString *width = array[0];
                frame.size.height = [height doubleValue]*280/[width doubleValue];
                frame.size.width = 280;
            }
            else{
                frame.size.height = 50;
                frame.size.width = 50;
            }
         
            
        }
        
        frame.origin.y = frame.origin.y + frame.size.height+5;
        
    }
    return  frame.origin.y+10;
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
