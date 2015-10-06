//
//  DemoContentView.h
//  Examples
//
//  Created by Chris Xu on 2014/5/2.
//  Copyright (c) 2014年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPPCAlertView;
typedef void(^ActionHandler)(UPPCAlertView *view);
@interface UPPCAlertView : UIView

@property (nonatomic, copy) ActionHandler dismissHandler;

/**
 *  View for messages
 *
 *  @return Return UIView for use.
 */
+ (UPPCAlertView *)defaultView;

@end
