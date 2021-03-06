//
//  Provincia.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 20/8/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Provincia : NSManagedObject

@property (nonatomic, retain) NSNumber * id_provincia;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * idLocal;

@end
