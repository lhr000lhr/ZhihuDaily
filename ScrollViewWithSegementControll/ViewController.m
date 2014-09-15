//
//  ViewController.m
//  ScrollViewWithSegementControll
//
//  Created by 浩然 on 14/9/2.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "ViewController.h"
#import "ScrollViewDetailViewController.h"
@interface ViewController ()
{
   NSMutableArray *imageArray;
}
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
       self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.title=@"知乎日报";

    //通过背景图片来设置背景
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
   UIImage *backgroundImage = [UIImage imageNamed:@"nav-bg.png"];  //获取图片
    
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  //设置背景
    
    
    
    UIColor * color = [UIColor whiteColor];
    
    
    
       //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
       //大功告成
    
    self.navigationController.navigationBar.titleTextAttributes = dict;

    _m_ScrollView.scrollEnabled = YES;
    _m_ScrollView.delegate = self;
    _m_ScrollView.contentSize = CGSizeMake(640, self.view.frame.size.height);
    _m_ScrollView.bounces = YES;
    _m_ScrollView.pagingEnabled = YES;
    _m_ScrollView.showsHorizontalScrollIndicator = NO;
    
   // self.pageController.numberOfPages=2; //设置页数为2
   // self.pageController.currentPage=0; //初始页码为 0
   // self.pageController.userInteractionEnabled=NO; //pagecontroller不响应点击操作
   // self.pageController.alpha=0;
    
    self.m_OneView = [[OneViewController alloc] initWithStyle:UITableViewStylePlain];
    self.m_TwoView = [[TwoViewController alloc] initWithStyle:UITableViewStylePlain];
    self.m_OneView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [_m_ScrollView addSubview:self.m_OneView.view];
    [self addChildViewController:self.m_OneView];
    [self.m_OneView didMoveToParentViewController:self];
    CGRect frame = _m_ScrollView.bounds;
    self.m_OneView.view.frame = frame;
    
    self.m_TwoView = [[TwoViewController alloc] initWithStyle:UITableViewStylePlain];
    self.m_TwoView.view.frame = CGRectMake(320, 0, _m_ScrollView.frame.size.width, _m_ScrollView.frame.size.height);
    
    
    [self addChildViewController:self.m_TwoView];
    [_m_ScrollView addSubview:self.m_TwoView.view];
    [self.m_OneView didMoveToParentViewController:self];
   // self.m_ScrollView.scrollsToTop=YES;
       
   // self.tableview=self.m_OneView.tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView== _m_ScrollView){
        
        CGPoint offset = scrollView.contentOffset;
        int page = offset.x / (self.view.bounds.size.width); //计算当前的页码
        self.Segment.selectedSegmentIndex = page; //设置scrollview的显示为当前滑动到的页面
    }
}


- (IBAction)toggleControls:(UISegmentedControl *)sender {
    

        
        

        
        
        [_m_ScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (sender.selectedSegmentIndex ),               _m_ScrollView.contentOffset.y) animated:YES];
        
    
}

@end
