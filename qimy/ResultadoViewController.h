//
//  ResultadoViewController.h
//  qimy
//
//  Created by Agustín Embuena on 17/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSublimationView.h"
#import <iAd/iAd.h>

@interface ResultadoViewController : UIViewController <LGSublimationViewDelegate, ADBannerViewDelegate, UIAlertViewDelegate>
@property bool isFichaChat;
@property NSArray *resultados;
@property NSArray *images;
@property (weak, nonatomic) IBOutlet UIButton *noqimy;
@property BOOL bannerIsVisible;
@property ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIView *viewBotones;

- (IBAction)qimy:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewQimy;
- (IBAction)irAChat:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *textoQimy;
@property (weak, nonatomic) IBOutlet UIButton *closeView;
@property (weak, nonatomic) IBOutlet UILabel *twxtoQimy2;
- (IBAction)closeView:(id)sender;

@end
