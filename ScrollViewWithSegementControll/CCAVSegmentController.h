//
//  CCAVSegmentController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-10.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CCAVSegmentControllerDelegate <NSObject>
@optional
-(void)segmentControllDidClicked:(UIButton *)sender;
@end


@interface CCAVSegmentController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *leftButton;
 
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property(nonatomic,retain)id<CCAVSegmentControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *newsDate;
@property(strong ,nonatomic) NSDate *date;

@end
