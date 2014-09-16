//
//  SettingTableViewController.m
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-9-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import "SettingTableViewController.h"
#import "AppDelegate.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

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
    SinaWeibo *sinaWeibo =[self sinaweibo];
    
    
    //////////////按钮状态
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:)
												 name:@"changeName" object:nil];
    if ([sinaWeibo isAuthValid]) {
        NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        
        self.userName.text =temp;
          [self.userImage setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url" ]]];
        //[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }
    if (section==3) {
        return 1;
    }
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            [self sendEmail:@"lee_peter@foxmail.com" cc:@"" subject:@"报告问题" body:@"( ⊙ o ⊙ )啊！_(:з」∠)_啊！"];
        }
        else if (indexPath.row==1){
            UIAlertView *alert = [UIAlertView new];
         
            alert = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:@"缓存已经清理~~~" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
             [alert show];
            
        }
        
        
    }else if(indexPath.section == 3)
        
    { [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
          SinaWeibo *sinaWeibo =[self sinaweibo];
        [self.weibo logoutButtonPressed];
        [self.weibo sinaweiboDidLogOut:sinaWeibo];
        [sinaWeibo removeAuthData];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil];
        UIAlertView *alert = [UIAlertView new];
        
        alert = [[UIAlertView alloc]initWithTitle:@"_(:з」∠)_" message:@"注销咯！！！！" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
             }
   
    
}
-(void)test:(NSNotification*)notify
{
    NSString *temp =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    if (temp) {
        [self.userImage setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"profile_image_url" ]]];
        self.userName.text =temp;

    }else{
        self.userName.text =@"使用新浪微博登陆";
         [self.userImage setImage:[UIImage imageNamed:@"gen_share_sine"]];
    }

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
- (void) sendEmail:(NSString *)phoneNumber
{
    NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", phoneNumber]];
    NSLog(@"send sms, URL=%@", phoneNumberURL);
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}

- (IBAction)settingSwitch:(UISwitch *)sender {
    
    if (sender.tag==0) { /////无图模式
        
        BOOL storeState = sender.isOn;
        [[NSUserDefaults standardUserDefaults]setBool:storeState forKey:@"picState"];
    }
    else if(sender.tag ==1){ ///离线下载
        
        BOOL storeState = sender.isOn;
        [[NSUserDefaults standardUserDefaults]setBool:storeState forKey:@"downLoadState"];
    }
    
    
    
    
}

-(void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
    NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
                     to, cc, subject, body];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

@end
