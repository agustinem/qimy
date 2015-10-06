//
//  GeolocalizacionCell.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 7/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeolocalizacionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelGeolo;
- (IBAction)geoloAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchGeolo;

@end
