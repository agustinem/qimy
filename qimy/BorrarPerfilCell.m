//
//  BorrarPerfilCell.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 18/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "BorrarPerfilCell.h"
#import "Util.h"
#import "WSService.h"
#import "Perfil.h"
#import "BDServices.h"
#import "Constants.h"

@implementation BorrarPerfilCell

-(void)awakeFromNib{
 
    if(_buttonBorrar.tag==25){
        [_buttonBorrar setTitle:NSLocalizedString(@"tabbar_menu_3", nil) forState:UIControlStateNormal];
    }else{
        [_buttonBorrar setTitle:NSLocalizedString(@"perfil_eliminar_boton", nil) forState:UIControlStateNormal];
    }
        [_sobreNosotros setTitle:NSLocalizedString(@"perfil_sobre_nosotros_boton", nil) forState:UIControlStateNormal];
}


- (IBAction)borrarAction:(id)sender {
    UIButton *but = (UIButton *)sender;
    if(but.tag == 25){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buscarNot" object:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"eliminarButton_perfil", nil) message:NSLocalizedString(@"notifica_eliminar_perfil", nil) delegate:self cancelButtonTitle:@"NO" otherButtonTitles:NSLocalizedString(@"eliminarButton_perfil", nil), nil];
        alert.tag = 2;
        alert.delegate= self;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1)
    {
        [[WSService sharedInstance] borrarPerfil:[[BDServices sharedInstance] obtenerPerfil]];
    }
}

- (IBAction)buttonSobreNosotros:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLWEB ]];
}
@end
