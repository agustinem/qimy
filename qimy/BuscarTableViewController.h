//
//  BuscarTableViewController.h
//  qimy
//
//  Created by Agustín Embuena on 17/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface BuscarTableViewController : UITableViewController <ADBannerViewDelegate>
@property BOOL bannerIsVisible;
@property ADBannerView *adBanner;
- (IBAction)buscarAction:(id)sender;

@end
