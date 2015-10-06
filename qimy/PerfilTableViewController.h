//
//  PerfilTableViewController.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FotosTableViewCell.h"
#import "UzysAssetsPickerController.h"
#import <iAd/iAd.h>

@interface PerfilTableViewController : UITableViewController <ChangePictureProtocolo,UzysAssetsPickerControllerDelegate,ADBannerViewDelegate>
    @property BOOL bannerIsVisible;
    @property ADBannerView *adBanner;

@end
