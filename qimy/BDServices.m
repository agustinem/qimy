//
//  BDServices.m
//  qimy
//
//  Created by Agustín Embuena Majúa on 14/6/15.
//  Copyright (c) 2015 Kometasoft SL. All rights reserved.
//

#import "BDServices.h"
#import "Perfil.h"
#import "Usuario.h"
#import "Constants.h"
#import "SDZUsuarioWS.h"
#import "SDZProvinciaWS.h"
#import "SDZEncuentroWS.h"
#import "SDZMensajeWS.h"
#import "SDZBannerWS.h"
#import "Provincia.h"
#import "Util.h"
#import "Mensaje.h"
#import "Encuentro.h"
#import "Publicidad.h"
#import "ConsultaMensaje.h"
#import <KVNProgress/KVNProgress.h>
@interface BDServices()



@end

@implementation BDServices

+(BDServices *)sharedInstance{
    
    static BDServices *new = nil;
    if(new== nil){
        new = [BDServices new];
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        new.context = [appDelegate managedObjectContext];
    }
    return new;
}



-(void)insertarPerfil:(SDZUsuarioWS *)_perfil{
    //quito el rastro de imágenes locales
    for(int i=0; i<5; i++){
        NSString *nombre = [NSString stringWithFormat:@"imageLocal%d",i];
        [[Util sharedInstance] removeImage:nombre];
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Perfil" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    if (fetchedObjects == nil) {
        NSLog(@"Error en la búsqueda");
    }else if([fetchedObjects count] >0){
        [self.context deleteObject:[fetchedObjects lastObject]];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    Perfil *perfil = [NSEntityDescription insertNewObjectForEntityForName:@"Perfil" inManagedObjectContext:self.context];
    perfil.nombre = _perfil.nombre;
    perfil.edad = [[NSNumber alloc] initWithInt:_perfil.edad] ;
    perfil.descripcion = _perfil.descripcion;
    perfil.esbot =[[NSNumber alloc] initWithInt: _perfil.esbot] ;
    perfil.sexo = [[NSNumber alloc] initWithInt: _perfil.sexo] ;
    perfil.interesahombre =[[NSNumber alloc] initWithInt: _perfil.interesahombre] ;
    perfil.interesamujer = [[NSNumber alloc] initWithInt: _perfil.interesamujer] ;
    perfil.longitud = [[NSNumber alloc] initWithInt: _perfil.longitud] ;
    perfil.latitud = [[NSNumber alloc] initWithInt: _perfil.latitud] ;
    perfil.idProvincia = [[NSNumber alloc] initWithInt: _perfil.idprovincia] ;
    perfil.fotos = [_perfil.fotos componentsJoinedByString:@"***"];
    perfil.idPerfil = [[NSNumber alloc] initWithInt: _perfil._id] ;
    
    
    //inciializo las variables
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DicKey"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fotosBajadas"];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"fotoPrincipal"];
    //cargo las bajadas
    [[Util sharedInstance]saveFotosBajadas:_perfil.fotos];
    //inicializo las eliminadas
    [[Util sharedInstance] saveFotosEliminadas:[NSArray new]];
    
    if(_perfil.fotos!=nil){
        
        [_perfil.fotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *nombreFoto = obj;
            if ([nombreFoto containsString:@"principal_"]) {
                nombreFoto = [nombreFoto stringByReplacingOccurrencesOfString:@"principal_" withString:@""];
                [[Util sharedInstance]saveNombreFotoPrincipal:nombreFoto];
                perfil.fotoSeleccionada = [[NSNumber alloc] initWithUnsignedInteger: idx+1];
            }
            NSURL *urlPhoto = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,nombreFoto]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPhoto]];
            [[Util sharedInstance] saveImgePerfil:nombreFoto image:image scale:1.0];
        }];
    }
    
    //        perfil.fotoSeleccionada =[[NSNumber alloc] initWithInt:  _perfil.fotos] ;
    
    //        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    //            //imagen de sugerido
    //            if([destiny.orden intValue] >0){
    //                NSString *destinyNamePhoto = [[UPPCUtil sharedInstance]name:destiny.url_foto_portada type:@"sugerido"];
    //
    //            }
    //        });
    
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
}

-(void)eliminarEncuentros:(int)idUser{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Encuentro" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Encuentro *encuentro in fetchedObjects) {
        [self.context deleteObject:encuentro];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }

    
}

-(void)eliminaUsuario:(Usuario *)usuario{
    NSError *error;
    [self.context deleteObject:usuario];
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    
}

-(void)insertarUsuarios:(NSArray *)usuarios{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Usuario" inManagedObjectContext:_context];
    
    //elimino todas las provincias que había
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Usuario *usuario in fetchedObjects) {
        [self.context deleteObject:usuario];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    //inserto todas las nuevas
    for (SDZUsuarioWS *_user in usuarios) {
        Usuario *user =[NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:self.context];
        user.nombre = _user.nombre;
        user.edad = [[NSNumber alloc] initWithInt:_user.edad] ;
        user.descripcion = _user.descripcion;
        user.esbot =[[NSNumber alloc] initWithInt: _user.esbot] ;
        user.sexo = [[NSNumber alloc] initWithInt: _user.sexo] ;
        user.interesahombre =[[NSNumber alloc] initWithInt: _user.interesahombre] ;
        user.interesamujer = [[NSNumber alloc] initWithInt: _user.interesamujer] ;
        user.longitud = [[NSNumber alloc] initWithInt: _user.longitud] ;
        user.latitud = [[NSNumber alloc] initWithInt: _user.latitud] ;
        user.idProvincia = [[NSNumber alloc] initWithInt: _user.idprovincia] ;
        user.fotos = [_user.fotos componentsJoinedByString:@"***"];
        user.idPerfil = [[NSNumber alloc] initWithInt: _user._id] ;
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


-(NSArray *)obtenerUsuarios{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Usuario" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    return [self.context executeFetchRequest:fetchRequest error:&error];
}

-(NSArray *)obtenerEncuentros{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Encuentro" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idEncuentro"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //search exists elements
    NSError *error = nil;
    return [self.context executeFetchRequest:fetchRequest error:&error];
}


-(NSArray *)obtenerMensajes:(int)idEncuentro{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mensaje" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idEncuentro == %d", idEncuentro];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idEncuentro"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //search exists elements
    NSError *error = nil;
    return [self.context executeFetchRequest:fetchRequest error:&error];
}




-(void)insertarEncuentros:(NSArray *)_insertar{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Encuentro" inManagedObjectContext:_context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Encuentro *encuentro in fetchedObjects) {
        [self.context deleteObject:encuentro];
        
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    for (SDZEncuentroWS *encuentorWS in _insertar) {
        NSDate * date = [[Util sharedInstance] dateFormatWS:encuentorWS.fechaUltimoMensaje];
        NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateStyle = NSDateIntervalFormatterLongStyle;
        dateFormat.timeZone = tz;
        NSString *dateStr = [dateFormat stringFromDate:date];

        Encuentro *encuentro =[NSEntityDescription insertNewObjectForEntityForName:@"Encuentro" inManagedObjectContext:self.context];
        encuentro.idUser = [[NSNumber alloc] initWithInt:encuentorWS.idOtroUsuario];
        encuentro.idEncuentro = [[NSNumber alloc] initWithInt:encuentorWS._id];
        encuentro.fechaUltimoMensaje = dateStr;
        encuentro.fotoPrincipal = encuentorWS.fotoPrincipal;
        encuentro.ultimoMensaje = encuentorWS.ultimoMensaje;
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


-(void)insertarProvincias:(NSArray *)_provincias{
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Provincia" inManagedObjectContext:_context];
    
    //elimino todas las provincias que había
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Provincia *provin in fetchedObjects) {
        [self.context deleteObject:provin];
        
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    int indiceArray =0;
    //inserto todas las nuevas
    for (SDZProvinciaWS *provWS in _provincias) {
        Provincia *prov =[NSEntityDescription insertNewObjectForEntityForName:@"Provincia" inManagedObjectContext:self.context];
        prov.id_provincia = [[NSNumber alloc] initWithInt:provWS._id];
        prov.nombre = provWS.nombre;
        prov.latitud =[[NSNumber alloc] initWithDouble: provWS.latitud];
        prov.longitud =[[NSNumber alloc]  initWithDouble: provWS.longitud];
        prov.idLocal =[[NSNumber alloc]  initWithInt: indiceArray];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        indiceArray++;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"OK" forKey:@"provincias"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProvincias object:self userInfo:nil];
}


-(NSArray *)obtenerProvincias{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Provincia" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre"
    //                                                                   ascending:YES];
    //    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    //search exists elements
    NSError *error = nil;
    return [self.context executeFetchRequest:fetchRequest error:&error];
}

-(Provincia *)obtenerProvincia:(int)idProvincia{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Provincia" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_provincia == %d", idProvincia];
    [fetchRequest setPredicate:predicate];
    //search exists elements
    NSError *error = nil;
    NSArray * consulta =[self.context executeFetchRequest:fetchRequest error:&error] ;
    if([consulta count]>0)
        return [consulta objectAtIndex:0];
    else
    {
        return  nil;
    }
}


-(void) eliminarPerfil{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Perfil" inManagedObjectContext:self.context]];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    Perfil  * perfilActual=[results objectAtIndex:0];
    [self.context deleteObject:perfilActual];
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(void) editPerfil:(Perfil *)nuevoPerfil{
    //    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    [request setEntity:[NSEntityDescription entityForName:@"Perfil" inManagedObjectContext:self.context]];
    NSError *error = nil;
    //    NSArray *results = [self.context executeFetchRequest:request error:&error];
    //    Perfil  * perfilActual=[results objectAtIndex:0];
    //    perfilActual = nuevoPerfil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


-(Perfil *)obtenerPerfil{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Perfil" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"no hay perfil guardado");
    }
    if([fetchedObjects count]>0)
        return  [fetchedObjects objectAtIndex:0];
    return nil;
}


-(ConsultaMensaje *)obtenerConsulta:(int)idUser{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConsultaMensaje" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idUser == %d", idUser];
    [fetchRequest setPredicate:predicate];
    //search exists elements
    NSError *error = nil;
    NSArray * consulta =[self.context executeFetchRequest:fetchRequest error:&error] ;
    if([consulta count]>0)
        return [consulta objectAtIndex:0];
    else
    {
        return  nil;
    }
}


-(void)insertarConsulta:(int)idUser fecha:(NSString *)fecha lastId:(int)lastid{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ConsultaMensaje" inManagedObjectContext:_context];
    
    //elimino todas las provincias que había
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idUser == %d",  idUser];
    [fetchRequest setPredicate:predicate];
    
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (ConsultaMensaje *consulta in fetchedObjects) {
        [self.context deleteObject:consulta];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    //inserto todas las nuevas
    
    ConsultaMensaje *cm =[NSEntityDescription insertNewObjectForEntityForName:@"ConsultaMensaje" inManagedObjectContext:self.context];
    cm.lastid = [[NSNumber alloc] initWithInt:lastid];
    cm.fecha = fecha;
    cm.idUser = [[NSNumber alloc] initWithInt:idUser];
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}


-(void)insertarMensajess:(NSArray *)_insertar{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mensaje" inManagedObjectContext:_context];
    
    //elimino todas las provincias que había
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Mensaje *mensaje in fetchedObjects) {
        [self.context deleteObject:mensaje];
        
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }

    int idMatch = 0;
    for (SDZMensajeWS *mensajeWS in _insertar) {
        Mensaje *m =[NSEntityDescription insertNewObjectForEntityForName:@"Mensaje" inManagedObjectContext:self.context];
        if(mensajeWS.idmatch>0)
            idMatch= mensajeWS.idmatch;
        m.idMensaje = [[NSNumber alloc] initWithInt:mensajeWS._id];
        m.idEmisor = [[NSNumber alloc] initWithInt:mensajeWS.idemisor];
        m.idReceptor = [[NSNumber alloc] initWithInt:mensajeWS.idreceptor];
        m.mensaje = mensajeWS.mensaje;
        m.idEncuentro = [[NSNumber alloc] initWithInt:mensajeWS.idmatch];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

    }

    NSDate * date = [NSDate date];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateIntervalFormatterLongStyle;
    dateFormat.timeZone = tz;
    NSString *dateStr = [dateFormat stringFromDate:date];
    SDZMensajeWS *ultimoMensaje = [_insertar lastObject];
    [[BDServices sharedInstance] insertarConsulta:idMatch fecha:dateStr lastId: ultimoMensaje._id];
    
}



-(Usuario *)obtenerUsuario:(int)idUser{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Usuario" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idUsuario == %d", idUser];
    [fetchRequest setPredicate:predicate];
    //search exists elements
    NSError *error = nil;
    NSArray * consulta =[self.context executeFetchRequest:fetchRequest error:&error] ;
    if([consulta count]>0)
        return [consulta objectAtIndex:0];
    else
    {
        return  nil;
    }
}

-(void)insertarPublicidad:(NSArray *)_publicidades{
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Publicidad" inManagedObjectContext:_context];
    
//    elimino  las publi que había
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //search exists elements
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    //delete element if exists
    for (Publicidad *publi in fetchedObjects) {
        [self.context deleteObject:publi];
        
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    //inserto todas las nuevas
    for (SDZBannerWS *bannerWS in _publicidades) {
        Publicidad *publi =[NSEntityDescription insertNewObjectForEntityForName:@"Publicidad" inManagedObjectContext:self.context];
        publi.ruta = bannerWS.ruta;
        publi.peso = [[NSNumber alloc] initWithInt:bannerWS.peso ];
        publi.web = bannerWS.web;
        publi.idpubli =  [[NSNumber alloc] initWithInt:bannerWS._id];
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


-(NSArray *)obtenerPubli{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Publicidad" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    return [self.context executeFetchRequest:fetchRequest error:&error];
}

@end

