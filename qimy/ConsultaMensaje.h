//
//  ConsultaMensaje.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConsultaMensaje : NSManagedObject

@property (nonatomic, retain) NSString * fecha;
@property (nonatomic, retain) NSNumber * lastid;
@property (nonatomic, retain) NSNumber * idUser;

@end
