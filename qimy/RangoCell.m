//
//  RangoCell.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 8/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "RangoCell.h"
#import "Util.h"

@implementation RangoCell

-(void)awakeFromNib{
    if(!([[Util sharedInstance]getDistanciaMax]>0)){
        [[NSUserDefaults standardUserDefaults] setFloat:25 forKey:@"distanciaMax"];
        [[NSUserDefaults standardUserDefaults] setFloat:50 forKey:@"rangoMax"];
        [[NSUserDefaults standardUserDefaults] setFloat:25 forKey:@"rangoMin"];
    }

//    if(_viewRange.tag ==10){
//        //innicializa
//        //distancia
//        _viewRange.selectedMaximum = [[Util sharedInstance] getDistanciaMax];
//        _viewRange.delegate = self;
//    }else{
//            NSLog(@"%f",[[Util sharedInstance] rangoMin]);
//        _viewRange.selectedMinimum = [[Util sharedInstance] rangoMin];
//        NSLog(@"%f",[[Util sharedInstance] rangoMax]);
//        _viewRange.selectedMaximum = [[Util sharedInstance] rangoMax];
//            _viewRange.delegate = self;
//    }
    _distanciaSlider.maximumValue= 500;
    _distanciaSlider.minimumValue= 0;
    _distanciaSlider.currentValue =[[Util sharedInstance] getDistanciaMax];
    _distanciaSlider.step=1.;
    [_distanciaSlider addTarget:self action:@selector(valueChangedDistancia) forControlEvents:UIControlEventValueChanged];

    _edadRango.maximumValue= 60;
    _edadRango.minimumValue= 18;
    _edadRango.currentLowerValue=[[Util sharedInstance] rangoMin];
    _edadRango.currentUpperValue=[[Util sharedInstance] rangoMax];
    _edadRango.step=1.;
    _edadRango.minimumDistance=1.;
    [_edadRango addTarget:self action:@selector(valueChangedEdad) forControlEvents:UIControlEventValueChanged];
    _maxDistanciaLabel.text =[NSString stringWithFormat:@"%dKm", (int)_distanciaSlider.currentValue];
    _minEdadLabel.text = [NSString stringWithFormat:@"%d", (int)_edadRango.currentLowerValue];
    _maxEdad.text = [NSString stringWithFormat:@"%d", (int)_edadRango.currentUpperValue];
    
}

-(void)valueChangedDistancia{
    [[Util sharedInstance]distanciaMax:_distanciaSlider.currentValue];
    _maxDistanciaLabel.text =[NSString stringWithFormat:@"%dKm",(int) _distanciaSlider.currentValue];
}

-(void)valueChangedEdad{
    [[Util sharedInstance]rangoMax:_edadRango.currentUpperValue];
    [[Util sharedInstance]rangoMin:_edadRango.currentLowerValue];

    _minEdadLabel.text = [NSString stringWithFormat:@"%d", (int)_edadRango.currentLowerValue];
    _maxEdad.text = [NSString stringWithFormat:@"%d",(int) _edadRango.currentUpperValue];
}

//
//-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
//    if(_viewRange.tag == 10){
//        //distancia
//        [[Util sharedInstance]distanciaMax:selectedMaximum];
//    }else{
//        [[Util sharedInstance]rangoMax:selectedMaximum];
//        [[Util sharedInstance]rangoMin:selectedMinimum];
//    }
//}

@end
