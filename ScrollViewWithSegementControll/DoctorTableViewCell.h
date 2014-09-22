//
//  DoctorTableViewCell.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-3.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//#import "UIImageView+WebCache.h"
@interface DoctorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *DoctorImage;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *workplace;

//- (IBAction)stars:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *stars;

-(void)creatThread:(NSString *)url ;

@end
