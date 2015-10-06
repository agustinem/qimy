//
//  GeolocalizacionCell.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 7/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "GeolocalizacionCell.h"
#import "Util.h"
#import "Perfil.h"
#import "BDServices.h"

@implementation GeolocalizacionCell


- (void)awakeFromNib {
    _labelGeolo.text=NSLocalizedString(@"buscar_geolocalizar", nil);
    [_switchGeolo setOn:[[Util sharedInstance]isGeolo]];
    if(![_switchGeolo isOn]){
        Perfil *perfil = [[BDServices sharedInstance]obtenerPerfil];
        perfil.longitud = 0;
        perfil.latitud = 0;
        [[BDServices sharedInstance]editPerfil:nil];
    }else{
        [[Util sharedInstance] startStandardUpdates:nil];
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied) {
            NSLog(@"Location services denied");
            [_switchGeolo setOn:false];         
        }
    }
}

- (IBAction)geoloAction:(id)sender {
    UISwitch *button = (UISwitch *)sender;
    NSDictionary * userinfo = @{@"activado":@"yes"};
    [[Util sharedInstance]isGeolo:button.on];
    if(button.on){
        userinfo = @{@"activado":@"yes"};
        [[Util sharedInstance] startStandardUpdates:nil];
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied) {
            NSLog(@"Location services denied");
            [button setOn:false];
            userinfo = @{@"activado":@"no"};
        }
    }else{
        Perfil *perfil = [[BDServices sharedInstance]obtenerPerfil];
        perfil.longitud = 0;
        perfil.latitud = 0;
        [[BDServices sharedInstance]editPerfil:nil];
        userinfo = @{@"activado":@"no"};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activaGeolo" object:nil userInfo:userinfo];
}
@end
