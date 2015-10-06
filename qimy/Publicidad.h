//
//  Publicidad.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 20/8/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Publicidad : NSManagedObject

@property (nonatomic, retain) NSString * ruta;
@property (nonatomic, retain) NSNumber * idpubli;
@property (nonatomic, retain) NSNumber * peso;
@property (nonatomic, retain) NSString * web;

@end
