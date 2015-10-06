//
//  RangeStyle.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 20/8/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "RangeStyle.h"
#import "Util.h"
#import "Constants.h"
@implementation RangeStyle

- (UIImage *)unselectedLineImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3., 2.), NO, [[UIScreen mainScreen] scale]);
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., 3., 2.)];
    
    [UIColor.grayColor setFill];
    [rectanglePath fill];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [thumbnail resizableImageWithCapInsets:UIEdgeInsetsMake(0., 1., 0., 1.) resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)selectedLineImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3., 2.), NO, [[UIScreen mainScreen] scale]);
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., 3., 2.)];
    
    [[Util colorFromHexString:@"257d34"] setFill];
    [rectanglePath fill];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [thumbnail resizableImageWithCapInsets:UIEdgeInsetsMake(0., 1., 0., 1.) resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)handlerImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(28., 28.), NO, [[UIScreen mainScreen] scale]);
    UIColor *color = [Util colorFromHexString:@"257d34"];
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0., 0., 28., 28.)];

    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 ){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(18., 18.), NO, [[UIScreen mainScreen] scale]);
        ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0., 0., 18., 18.)];

    }
    
    [color setFill];
    [ovalPath fill];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}


@end
