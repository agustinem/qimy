//
//  BDServices.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 14/6/15.
//  Copyright (c) 2015 Kometasoft SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Perfil,SDZUsuarioWS, Usuario, ConsultaMensaje, Provincia;
@interface BDServices : NSObject

@property  NSManagedObjectContext *context;
+(BDServices *)sharedInstance;
-(void)insertarProvincias:(NSArray *)_provincias;
-(NSArray *)obtenerProvincias;
-(Provincia *)obtenerProvincia:(int)idProvincia;
-(void)insertarPerfil:(SDZUsuarioWS *)_perfil;
-(Perfil *)obtenerPerfil;
-(void) editPerfil:(Perfil *)nuevoPerfil;
-(void) eliminarPerfil;
-(void)insertarUsuarios:(NSArray *)usuarios;
-(NSArray *)obtenerUsuarios;
-(void)eliminaUsuario:(Usuario *)usuario;
-(NSArray *)obtenerEncuentros;
-(void)insertarEncuentros:(NSArray *)_insertar;
-(NSArray *)obtenerMensajes:(int)idEncuentro;
-(void)insertarMensajess:(NSArray *)_insertar;
-(void)insertarConsulta:(int)idUser fecha:(NSString *)fecha lastId:(int)lastid;
-(ConsultaMensaje *)obtenerConsulta:(int)idUser;
-(void)eliminarEncuentros:(int)idUser;
-(void)insertarPublicidad:(NSArray *)_publicidades;
-(NSArray *)obtenerPubli;
@end
