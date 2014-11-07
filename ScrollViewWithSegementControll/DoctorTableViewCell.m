//
//  DoctorTableViewCell.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-3.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "DoctorTableViewCell.h"

@implementation DoctorTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



/////////////////配图/////////////////配图/////////////////配图/////////////////配图/////////////////配图

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:YES];
    // imagename=imageName;
}

//- (IBAction)stars:(UIButton *)sender {
//   // UIButton* button = (UIButton*)sender;
//    UITableViewCell* buttonCell = (UITableViewCell*)[[sender superview] superview];
//    [sender setImage:[UIImage imageNamed:@"star-rate-s"]forState:UIControlStateNormal];
//  //  NSIndexPath * path = [(UITableView*)[[[sender superview] superview]subviews ] indexPathForCell:buttonCell];
//   // NSLog(@"index row%d", [path row]);
//    //NSLog(@"view:%@", [[[sender superview] superview] description]);
////        UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
////        NSIndexPath * path = [self.tableView indexPathForCell:cell];
////        NSLog(@"index row%d", [path row]);
//}

-(void)creatThread:(NSString *)url {
    if (url !=nil) {
        self.DoctorImage.image=nil;
    }
    // self.Image2 = [[AsynImageView alloc] initWithFrame:i];
    // self.Image2.frame= i;
    // self.Image2.imageURL =url;
    [NSThread detachNewThreadSelector:@selector(setPic:) toTarget:self withObject:url];
}
-(void)setPic:(NSString *)url
{
    // NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    //  self.imageDictionary = [accountDefaults objectForKey:@"imageDictionary"];
    //  self.userimageDictionary =[accountDefaults objectForKey:@"userimageDictionary"];
    //NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"setPic线程开始");
    // UIImage *tempImage = [self.imageDictionary objectForKey:url];
    
    
    NSString *fileName = [url lastPathComponent];
    NSData *imageData = [NSData dataWithContentsOfFile: [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName]];
    
    UIImage *tempImage  = nil;
    tempImage =[UIImage  imageWithData:imageData];
    if (url != nil) {
        
        //tempImage =[UIImage imageWithContentsOfFile:fileName];
        //NSLog(@"data%@ image%@   ",[UIImage  imageWithData:imageData],[UIImage imageWithContentsOfFile:fileName]);
        self.DoctorImage.image=tempImage;
        
        
        // UIImage *tempImage =[UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:url]];
        
        if (self.DoctorImage.image == nil) {
            self.DoctorImage.image= nil;
            
            // self.Image.image =[UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            // [self.imageDictionary setValue:self.Image.image forKey:url];
            NSData  *storeData =[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            // [[NSUserDefaults standardUserDefaults] setObject:storeData forKey:url];
            
            self.DoctorImage.image =[UIImage  imageWithData:storeData];
            [self saveImage:self.DoctorImage.image withName:fileName];
            NSLog(@"Image重新下载");
            
            //  NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            
            
        }else{
            NSLog(@"微博配图正在使用缓存");
        }}
    else{
        self.DoctorImage.image = nil;
    }
    //  NSString *filePath =[self dataFilePath];
    // [self.imageDictionary writeToFile:filePath atomically:YES];
}

@end
