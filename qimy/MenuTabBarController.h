//
//  MenuTabBarController.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTabBarController : UITabBarController <UITabBarControllerDelegate>

@property int index;
-(void)barBuscar;
@end
