//
//  FichaQimy.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 16/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "FichaQimy.h"
#import "Constants.h"
@implementation FichaQimy


-(FichaQimy *)initWithImagePrincipal:(NSString *)imagePrin imagelist:(NSString *)images titulo:(NSString *)titulo desc:(NSString *)descripcion nombre:(NSString *)nombre idUser:(NSNumber *)idUser{

    _imageList = [[NSArray alloc] initWithArray:[images componentsSeparatedByString:@"***" ]];
//    _imagePrincipalURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,imagePrin]];
    _titulo = titulo;
    _descripcion = descripcion;
    _nombre = nombre;
    _idUsuario = idUser;
    return self;
}

@end
