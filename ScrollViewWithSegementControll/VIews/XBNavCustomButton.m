//
//  XBNavCustomButton.m
//  CCTV
//
//  Created by pengjay on 14-2-14.
//  Copyright (c) 2014年 pengjay.cn@gmail.com. All rights reserved.
//

#import "XBNavCustomButton.h"

@implementation XBNavCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        touchRect = CGRectMake(0, 0, 60, 40);
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        if ([self isLeftButton]) {
            frame.origin.x -= 16.0f;
        } else {
            frame.origin.x += 16.0f;
        }
    } else {
        if ([self isLeftButton]) {
            frame.origin.x -= 5.0f;
        } else {
            frame.origin.x += 5.0f;
        }
    }
    [super setFrame:frame];
}

- (BOOL)isLeftButton {
    return self.frame.origin.x < (self.superview.frame.size.width / 2);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tc = [touches anyObject];
    CGPoint p = [tc locationInView:self];
    if (CGRectContainsPoint(touchRect, p)) {
        [super touchesBegan:touches withEvent:event];
    }
    
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *tc = [touches anyObject];
//    CGPoint p = [tc locationInView:self];
//    if (CGRectContainsPoint(touchRect, p)) {
//        [super touchesEnded:touches withEvent:event];
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *tc = [touches anyObject];
//    CGPoint p = [tc locationInView:self];
//    if (CGRectContainsPoint(touchRect, p)) {
//        [super touchesCancelled:touches withEvent:event];
//    }
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *tc = [touches anyObject];
//    CGPoint p = [tc locationInView:self];
//    if (CGRectContainsPoint(touchRect, p)) {
//        [super touchesMoved:touches withEvent:event];
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
