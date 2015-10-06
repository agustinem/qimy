//
//  Encuentro.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Encuentro : NSManagedObject

@property (nonatomic, retain) NSString * fechaUltimoMensaje;
@property (nonatomic, retain) NSString * fotoPrincipal;
@property (nonatomic, retain) NSNumber * idUser;
@property (nonatomic, retain) NSString * ultimoMensaje;
@property (nonatomic, retain) NSNumber * idEncuentro;

@end
