//
//  ViewController.h
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "UIImageView+WebCache.h"
@interface ViewController : UIViewController<UIScrollViewDelegate>
{
  //  UIScrollView *m_ScrollView;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *Segment;


@property (strong, nonatomic)  IBOutlet UIScrollView *m_ScrollView;
@property (strong , nonatomic) OneViewController* m_OneView;


@property (strong , nonatomic) TwoViewController* m_TwoView;
@end

