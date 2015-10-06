//
//  ProvinciaTableViewCell.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "ProvinciaTableViewCell.h"
#import "Provincia.h"
#import "WSService.h"
#import "Constants.h"
#import "BDServices.h"
#import "Util.h"
#import "Perfil.h"

@interface ProvinciaTableViewCell()

@property NSInteger row;
@property NSArray *provincias;


@end

@implementation ProvinciaTableViewCell


-(void)geolocActivate:(NSNotification *)notifica{
    if([[notifica.userInfo objectForKey:@"activado"] isEqualToString:@"yes"] &&  (_picker.tag ==10))
        _picker.hidden= YES;
    else
        _picker.hidden= NO;
}

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configPicker:) name:kNotificationProvincias object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geolocActivate:) name:@"activaGeolo" object:nil];
    if ([_provinciaTF respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [Util colorFromHexString:@"257D34"];
        _provinciaTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"perfil_provincia", nil)     attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    //    _provinciaTF.placeholder = NSLocalizedString(@"perfil_provincia", nil);
    if(_picker.tag !=10){//10 es el picker de la pantalla buscar
        _picker = [UIPickerView new];
    }else if([[Util sharedInstance] isGeolo]){
        _picker.hidden= YES;
    }
    _picker.delegate = self;
    _picker.dataSource = self;
    [self configPicker:nil];
    
}

-(void)configPicker:(NSNotification *)not{
     _provincias = [[BDServices sharedInstance] obtenerProvincias];
    if(_picker.tag !=10){//10 es el picker de la pantalla buscar
        Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
        Provincia *provincia = [[BDServices sharedInstance]obtenerProvincia:[perfil.idProvincia intValue]];
        _row = [provincia.idLocal intValue];
        if(_provincias!= nil && [_provincias count]>_row){
            Provincia *pr=  [_provincias objectAtIndex:_row];
            _provinciaTF.text = pr.nombre;
            [_picker selectRow:_row inComponent:0 animated:NO];

        }else
            [_picker selectRow:0 inComponent:0 animated:NO];
        _provinciaTF.inputView = _picker;
        
        UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        [toolBar setBarStyle:UIBarStyleBlackTranslucent];
        UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                          style:UIBarButtonItemStyleDone target:self action:@selector(OkButton:)];
        toolBar.items = @[barButtonDone];
        barButtonDone.tintColor=[UIColor whiteColor];
        _provinciaTF.inputAccessoryView = toolBar;


    }else{
        Provincia *provincia = [[BDServices sharedInstance]obtenerProvincia:[[Util sharedInstance]provincia]];
        if([[Util sharedInstance]provincia] == 0)
        {
            Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
            provincia = [[BDServices sharedInstance]obtenerProvincia:[perfil.idProvincia intValue]];
        }


        [_picker selectRow:[provincia.idLocal intValue] inComponent:0 animated:NO];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_provincias count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Provincia *prov = [_provincias objectAtIndex:row];
    return prov.nombre;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _row = row;
    if(pickerView.tag ==10){
      Provincia *pr =   [_provincias objectAtIndex:row];
    [[Util sharedInstance]provinciaBusco:[pr.id_provincia intValue]];
    }
    
}

-(void)OkButton:(id)sender
{

    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    if([_provincias count]>=_row){

    Provincia *prov = [_provincias objectAtIndex:_row];
    perfil.latitud = prov.latitud;
    perfil.longitud = prov.longitud;
    perfil.idProvincia = prov.id_provincia;
    _provinciaTF.text = prov.nombre;
    [[BDServices sharedInstance] editPerfil:perfil];
    }else{
        [[WSService sharedInstance]getProvincias];
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"perfil_prov_err", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    [_provinciaTF resignFirstResponder];
}


@end
