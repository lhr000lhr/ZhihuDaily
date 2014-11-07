//
//  WeatherViewController.m
//  ScrollViewWithSegementControll
//
//  Created by qsheal on 14-10-30.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downLoadTvCircleData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)downLoadTvCircleData
{
    SinaWeiboRequest *_request = [SinaWeiboRequest requestWithURL:@"http://cdn.weather.hao.360.cn/api_weather_info.php"
                                                       httpMethod:@"GET"
                                                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"hao360",@"app",@"101190101",@"code",nil]
                                                         delegate:self];
    NSMutableSet *requests;
    [requests addObject:_request];
    [_request connect];
    
    //    api 服务器
    //    192.168.1.35  ?app=hao360&_jsonp=smartloaddata101190101&code=101190101
    //    58.68.243.109
    //    58.68.243.110
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    
    
    NSDictionary *dic = result;
    
    
    
}
-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
    
    
    
    
    
    
}
-(void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
    NSError *error;
    
    weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([result hasPrefix:@" callback"])
    {
        result = [result substringFromIndex:10];
        NSArray *arry=[result componentsSeparatedByString:@")"];
        result = arry[0];
        weatherDic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        
        
        [self setData:weatherDic];
    }
    
}


-(void)setData :(NSDictionary *)dataDic
{
    NSArray *weatherArray = [dataDic objectForKey:@"weather"];
    NSDictionary *today = weatherArray[0];
    self.date.text = [today objectForKey:@"date"];
    self.city.text = [[[dataDic objectForKey:@"area"] objectAtIndex:2] objectAtIndex:0];
//    self.temperature.text = [today objectForKey:@""];
    
    
}

@end
