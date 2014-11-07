//
//  CCTVGeneralThreadTableViewController.h
//  ScrollViewWithSegementControll
//
//  Created by zagger on 14-10-15.
//  Copyright (c) 2014年 浩然. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneViewController.h"
#import "TQRichTextView.h"
#import "TTTAttributedLabel.h"
#import "VoiceConverter.h"
#import "ChatVoiceRecorderVC.h"

@interface CCTVGeneralThreadTableViewController : UITableViewController<SinaWeiboRequestDelegate,TQRichTextViewDelegate,TTTAttributedLabelDelegate,VoiceRecorderBaseVCDelegate,AVAudioPlayerDelegate>
{
    NSMutableDictionary *receivedData;
    NSMutableDictionary *storeHeight;
    UIProgressView *progressV;      //播放进度
    NSTimer *timer;                 //监控音频播放进度
}
@property (strong , nonatomic)NSDictionary *rowData;
@property (retain, nonatomic)  ChatVoiceRecorderVC      *recorderVC;

@property (retain, nonatomic)   AVAudioPlayer           *player;
@property (copy, nonatomic)     NSString                *originWav;         //原wav文件名
@property (copy, nonatomic)     NSString                *convertAmr;        //转换后的amr文件名
@property (copy, nonatomic)     NSString                *convertWav;        //amr转wav的文件名
@end
