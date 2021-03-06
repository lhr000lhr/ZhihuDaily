//
//  WeiboTableViewCell.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-17.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeiboTableViewCell.h"

@implementation WeiboTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    CALayer *userImage = [self.userImage layer];   //获取ImageView的层
    [userImage setMasksToBounds:YES];
    [userImage setCornerRadius:6.0];
    CALayer *weiboImage = [self.weiboImage layer];   //获取ImageView的层
    [weiboImage setMasksToBounds:YES];
    [weiboImage setCornerRadius:6.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
