//
//  SexoTableViewCell.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "SexoTableViewCell.h"
#import "Util.h"
#import "Perfil.h"
#import "BDServices.h"
@implementation SexoTableViewCell

- (void)awakeFromNib {
    _labelSexo.text = NSLocalizedString(@"perfil_sexo", nil);
    _labelInteresa.text = NSLocalizedString(@"perfil_busca", nil);
    _labelTextoRango.text = NSLocalizedString(@"perfil_rango", nil);
    _buscoMujer= true;
    _buscoHombre=false;    
    _isMujer= false;
    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    if([perfil.edad intValue]>0){//significa que el perfil existe no es nuevo

        _buscoHombre = [perfil.interesahombre boolValue];
        _buscoMujer = [perfil.interesamujer boolValue];
        _isMujer =  [perfil.sexo boolValue];
        
      //pintando los valores
        if(_isMujer){
            [_selectedSex1 setBackgroundImage:[UIImage imageNamed:@"girl2" ] forState:UIControlStateNormal];
            [_selectedSex setBackgroundImage:[UIImage imageNamed:@"no-boy" ] forState:UIControlStateNormal];
        }else{
            [_selectedSex1 setBackgroundImage:[UIImage imageNamed:@"no-girl" ] forState:UIControlStateNormal];
            [_selectedSex setBackgroundImage:[UIImage imageNamed:@"boy2" ] forState:UIControlStateNormal];
        }
        if(_buscoMujer){
            [_interesaMujer setBackgroundImage:[UIImage imageNamed:@"girl1" ] forState:UIControlStateNormal];
        }else{
            [_interesaMujer setBackgroundImage:[UIImage imageNamed:@"no-girl" ] forState:UIControlStateNormal];
        }
        if(_buscoHombre){
            [_interesaHombre setBackgroundImage:[UIImage imageNamed:@"boy1" ] forState:UIControlStateNormal];
        }else{
            [_interesaHombre setBackgroundImage:[UIImage imageNamed:@"no-boy" ] forState:UIControlStateNormal];
        }        
    }else{
        //inicializo
        perfil.sexo = [[NSNumber alloc] initWithBool: _isMujer];
        perfil.interesahombre = [[NSNumber alloc] initWithBool: _buscoHombre];
        perfil.interesamujer = [[NSNumber alloc] initWithBool: _buscoMujer];
        [[BDServices sharedInstance]editPerfil:perfil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mujersexo:(id)sender {
    if(!_isMujer){
        Perfil *perfil= [[BDServices sharedInstance] obtenerPerfil];
        _isMujer= true;
        perfil.sexo = [[NSNumber alloc] initWithBool: _isMujer];
        [[BDServices sharedInstance]editPerfil:perfil];
        [_selectedSex1 setBackgroundImage:[UIImage imageNamed:@"girl2" ] forState:UIControlStateNormal];
        [_selectedSex setBackgroundImage:[UIImage imageNamed:@"no-boy" ] forState:UIControlStateNormal];
    }
    
}

- (IBAction)hombreSexo:(id)sender {
    if(_isMujer){
        Perfil *perfil= [[BDServices sharedInstance] obtenerPerfil];
        _isMujer=false;
        perfil.sexo = [[NSNumber alloc] initWithBool: _isMujer];
        [[BDServices sharedInstance]editPerfil:perfil];
        [_selectedSex1 setBackgroundImage:[UIImage imageNamed:@"no-girl" ] forState:UIControlStateNormal];
        [_selectedSex setBackgroundImage:[UIImage imageNamed:@"boy2" ] forState:UIControlStateNormal];
    }
}

- (IBAction)interesaMujer:(id)sender {
       Perfil *perfil= [[BDServices sharedInstance] obtenerPerfil];
    _buscoMujer=![perfil.interesamujer boolValue];
    if([self validate]){
        perfil.interesamujer = [[NSNumber alloc] initWithBool: _buscoMujer];
        [[BDServices sharedInstance]editPerfil:perfil];
        if(_buscoMujer){
            [_interesaMujer setBackgroundImage:[UIImage imageNamed:@"girl1" ] forState:UIControlStateNormal];
        }else{
            [_interesaMujer setBackgroundImage:[UIImage imageNamed:@"no-girl" ] forState:UIControlStateNormal];
        }
    }else{
        _buscoMujer=![perfil.interesamujer boolValue];
    }
}

- (IBAction)interesaHombre:(id)sender {
       Perfil *perfil= [[BDServices sharedInstance] obtenerPerfil];
    _buscoHombre=![perfil.interesahombre boolValue];
    if([self validate]){
        perfil.interesahombre = [[NSNumber alloc] initWithBool: _buscoHombre];
        [[BDServices sharedInstance]editPerfil:perfil];
        if(_buscoHombre){
            [_interesaHombre setBackgroundImage:[UIImage imageNamed:@"boy1" ] forState:UIControlStateNormal];
        }else{
            [_interesaHombre setBackgroundImage:[UIImage imageNamed:@"no-boy" ] forState:UIControlStateNormal];
        }
        
    }else{
        _buscoHombre=![perfil.interesahombre boolValue];
    }
}

-(bool)validate{
    if(!_buscoHombre && !_buscoMujer){
        [Util showDefaultContentView:NSLocalizedString(@"error_sexos", nil)];
        return false;
    }
    return true;
}

@end
