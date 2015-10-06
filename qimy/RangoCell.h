//
//  RangoCell.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 8/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMASliders/BMASlider.h>
#import <BMASliders/BMARangeSlider.h>

@interface RangoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet BMASlider *distanciaSlider;
@property (weak, nonatomic) IBOutlet BMARangeSlider *edadRango;

@property (weak, nonatomic) IBOutlet UILabel *maxDistanciaLabel;
@property (weak, nonatomic) IBOutlet UILabel *minEdadLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxEdad;
@end
