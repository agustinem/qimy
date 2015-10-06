//
//  PerfilTableViewCell.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "PerfilTableViewCell.h"
#import "BDServices.h"
#import "Constants.h"
#import "Perfil.h"
#import "Util.h"
#import <iAd/iAd.h>
#import <QuartzCore/QuartzCore.h>

@implementation PerfilTableViewCell

- (void)awakeFromNib {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cambiaFoto:) name:kNotificationChangeFoto object:nil];

    _descripcion.text = NSLocalizedString(@"perfil_descripcion_text", nil);
    _descripcion.delegate = self;
    _descripcion.textColor = [UIColor lightGrayColor];
    
    _edad.placeholder = NSLocalizedString(@"perfil_edad_TF", nil);
    _nombreTF.placeholder = NSLocalizedString(@"perfil_nombre_TF", nil);
    _nombreTF.delegate = self;
    _edad.delegate= self;
    
    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    _nombreTF.text = perfil.nombre;
    if([perfil.edad intValue]>0)
       _edad.text = [perfil.edad stringValue];
    if(![perfil.descripcion isEqualToString:@"" ]){
        _descripcion.text = perfil.descripcion;
            _descripcion.textColor = [UIColor darkGrayColor];
    }
    

    NSArray *fotos = [perfil.fotos componentsSeparatedByString:@"-"];
    if([fotos count]>0 && ![perfil.fotos isEqualToString:@""])
        _imagePerfil.image = [UIImage imageNamed:[fotos objectAtIndex:[perfil.fotoSeleccionada intValue]]];
    else
        _imagePerfil.image = [UIImage imageNamed:@"no-img"];
    
    _imagePerfil.layer.cornerRadius =  40;
    _imagePerfil.clipsToBounds = YES;

    
    _descripcion.inputAccessoryView = [self toolBar:100];
    _nombreTF.inputAccessoryView = [self toolBar:101];
    _edad.inputAccessoryView = [self toolBar:102];
    
}

-(void)OKbutton:(id)sender{
    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    UIBarButtonItem *bar = (UIBarButtonItem *)sender;
    if(bar.tag == 100){
        perfil.descripcion = _descripcion.text;
        [_descripcion resignFirstResponder];
    }else if (bar.tag == 101){
        perfil.nombre = _nombreTF.text;
        [_nombreTF resignFirstResponder];
    }else if(bar.tag == 102){
        perfil.edad = [[NSNumber alloc] initWithInteger:[_edad.text integerValue]];
        [_edad resignFirstResponder];
    }
    [[BDServices sharedInstance] editPerfil:perfil];
}

-(void)cambiaFoto:(NSNotification *)notifica{
    NSDictionary *userinfo = notifica.userInfo;
    _imagePerfil.image = [[Util sharedInstance]loadImagePerfil:[userinfo objectForKey:@"foto"]];
}



-(void)textFieldDidEndEditing:(UITextField *)textField{

    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    if (textField == _nombreTF) {
        perfil.nombre = _nombreTF.text;
    }else if(textField == _edad){
        perfil.edad = [[NSNumber alloc] initWithInteger:[_edad.text integerValue]];
    }
    [[BDServices sharedInstance] editPerfil:perfil];
    [textField resignFirstResponder];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"perfil_descripcion_text", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"perfil_descripcion_text", nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }else
        textView.textColor = [UIColor darkGrayColor]; //optional
    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    perfil.descripcion = textView.text;
    [[BDServices sharedInstance] editPerfil:perfil];
    [textView resignFirstResponder];
}



- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    if(textField == _edad){
        NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterNoStyle];
        
        NSString * newString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSNumber * number = [nf numberFromString:newString];
        
        if (number)
            return YES;
        else
            return NO;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 100;
}



-(void)textChanged:(NSNotification *)notification{
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(UIToolbar *)toolBar:(NSInteger)tag{
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                      
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(OKbutton:)];
    
    barButtonDone.tag=tag;
    barButtonDone.tintColor=[UIColor whiteColor];
    toolBar.items = @[barButtonDone];
    return toolBar;
}
@end
