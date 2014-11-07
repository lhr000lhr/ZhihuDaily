//
//  WeatherViewController.h
//  ScrollViewWithSegementControll
//
//  Created by qsheal on 14-10-30.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboRequest.h"
@interface WeatherViewController : UIViewController<SinaWeiboRequestDelegate>
{

    NSMutableDictionary *weatherDic;
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *pm25;









@end
