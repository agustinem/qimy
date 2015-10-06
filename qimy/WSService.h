//
//  WSService.h
//  qimy
//
//  Created by Agustín Embuena on 15/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Perfil;
@interface WSService : NSObject




+(WSService *)sharedInstance;
+(void) myUpdateMethod:(NSNotification *)notification;
-(void)obtenerAnuncios;
-(void)login:(NSString *) user pass:(NSString *)pass view:(UIView *)view :(double)longitud :(double)latitud;
-(void)registro:(NSString *)email pass:(NSString *)pass view:(UIView *)view;
-(void)getProvincias;
-(void)registrarDispositivo:(NSString *)email pass:(NSString *)pass;
-(void)editUsuarionuevopassword:(NSString *)nuevoP perfil:(Perfil *)p latitud:(float)lat longitud:(float)longitud ;
-(void)buscar:(Perfil *)perfil;
-(void)pedirClave:(NSString *)email;
-(void)borrarPerfil:(Perfil *)perfil;
-(void)editEncuentro:(int)myId envioAId:(int)idUser qimy:(int )qimyInt;
-(void)editDenuncia:(int)myId envioAId:(int)idUser;
-(void)editBloqueo:(int)myId envioAId:(int)idUser;
-(void)getUsuarioById:(int)idUser;
-(void)getAllEncuentro:(int)myId;
-(void)getAllMessages:(int)myId envioAId:(int)idUser match:(int )match lastID:(int)lastId fechaUltima:(NSString * )fechaUltima;
-(void)getLastMessage:(int)idMatch;
-(void)editMessage:(int)myId envioAId:(int)idUser match:(int )idMatch fecha:(NSString *)fecha mensaje:(NSString *)mensaje;

@end
