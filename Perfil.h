//
//  Perfil.h
//  qimy
//
//  Created by Agustín Embuena on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Perfil : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSNumber * desde;
@property (nonatomic, retain) NSNumber * edad;
@property (nonatomic, retain) NSNumber * esbot;
@property (nonatomic, retain) NSString * fotos;
@property (nonatomic, retain) NSNumber * fotoSeleccionada;
@property (nonatomic, retain) NSNumber * hasta;
@property (nonatomic, retain) NSNumber * idPerfil;
@property (nonatomic, retain) NSNumber * idProvincia;
@property (nonatomic, retain) NSNumber * interesahombre;
@property (nonatomic, retain) NSNumber * interesamujer;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * sexo;

@end
