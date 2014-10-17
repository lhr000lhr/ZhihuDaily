//
//  generalThreadTableViewCell.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-16.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@interface generalThreadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *floor;
@property (strong, nonatomic) IBOutlet UIButton *voiceButton;


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;






@property (strong, nonatomic) IBOutlet TTTAttributedLabel *content;

@end
