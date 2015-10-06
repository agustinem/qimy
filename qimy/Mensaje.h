//
//  Mensaje.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mensaje : NSManagedObject

@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSNumber * idEmisor;
@property (nonatomic, retain) NSNumber * idEncuentro;
@property (nonatomic, retain) NSNumber * idReceptor;
@property (nonatomic, retain) NSString * mensaje;
@property (nonatomic, retain) NSNumber * idMensaje;

@end
