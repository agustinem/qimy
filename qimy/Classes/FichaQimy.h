//
//  FichaQimy.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 16/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FichaQimy : NSObject

@property NSURL *imagePrincipalURL;
@property NSArray *imageList;
@property NSString *titulo;
@property NSString *nombre;
@property NSString *descripcion;
@property NSNumber * idUsuario;


-(FichaQimy *)initWithImagePrincipal:(NSString *)imagePrin imagelist:(NSString *)images titulo:(NSString *)titulo desc:(NSString *)descripcion nombre:(NSString *)nombre idUser:(NSNumber *)idUser;

@end
