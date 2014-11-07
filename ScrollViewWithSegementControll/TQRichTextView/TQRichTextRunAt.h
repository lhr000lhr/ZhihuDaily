//
//  TQRichTextRunAt.h
//  TQRichTextViewDemo
//
//  Created by zagger on 14-9-30.
//  Copyright (c) 2014年 fuqiang. All rights reserved.
//


#import "TQRichTextRun.h"

@interface TQRichTextRunAt : TQRichTextRun

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return TQRichTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end
