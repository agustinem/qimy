//
//  WSService.m
//  qimy
//
//  Created by Agustín Embuena on 15/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "WSService.h"
#import "BDServices.h"
#import "AppDelegate.h"
#import "SDZWsclassService.h"
#import "Util.h"
#import "Constants.h"
#import "Perfil.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FXReachability/FXReachability.h>
#import <KVNProgress/KVNProgress.h>


@interface WSService()


@property UIView * currentViewForHUD;
@property NSDictionary *facebookData;
//se usa para si el registor falla haga login
@property NSString *emailAuxRegistro;
@property NSString *claveAuxRegistro;
//facebook lllama dos veces simultaneas lo ponemos para que lo procesesolo una vez
@property int controlFacebookDelegate;

@property NSDictionary *userInfo;

@end

@implementation WSService

static SDZWsclassService *service = nil;
+(WSService *)sharedInstance{
    
    static WSService *new = nil;
    if(new== nil){
        new = [WSService new];
        service = [SDZWsclassService service];
        service.logging = YES;
    }
    return new;
}
#pragma mark-llamadas

-(void)login:(NSString *) user pass:(NSString *)pass view:(UIView *)view :(double)longitud :(double)latitud{
    if([self checkConnectivity:NSLocalizedString(@"ws_login",nil) view:view]){
        _emailAuxRegistro = user;
        _claveAuxRegistro = pass;
        [service login :self action:@selector(loginHandler:) email: user password: [Soap md5:_claveAuxRegistro] latitud:latitud longitud:longitud];
    }
}



-(void)registro:(NSString *)email pass:(NSString *)pass view:(UIView *)view{
    _emailAuxRegistro = email;
    _claveAuxRegistro = pass;
    NSString *emailAux = email;
    if([self checkConnectivity:NSLocalizedString(@"ws_login_reg",nil) view:view]){
        if([[Util sharedInstance] loginByFB]){
            emailAux = [@"*fb*" stringByAppendingString:emailAux];
        }
        [service registro:self action:@selector(registroHandler:) email: emailAux password:[Soap md5:_claveAuxRegistro]];
    }
}


-(void)getPerfil:(NSString *)user pass:(NSString *)pass view:(UIView *)view{
    //TODO: SERVICIO WEB PERFIL
}

-(void)getUsuarioById:(int)idUser{
    if([self checkConnectivity:NSLocalizedString(@"ws_getuser",nil) view:nil]){
        [service getUsuarioById:self action:@selector(userByIdHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idUsuario:idUser];
    }

}

-(void)getProvincias{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"provincias" ] isEqualToString:@"OK"]){
        [service getAllProvincia:self action:@selector(provinciasHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserOK object:self userInfo:_userInfo];

    }
}

-(void)registrarDispositivo:(NSString *)email pass:(NSString *)pass{
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(deviceID== nil)deviceID= @"-1";
    NSString *version = [Util getVersion];
    NSString *idioma = [Util getLengua];
    [service registrarDispositivo:self action:@selector(registrarDispositivoHandler:) email: email password: [Soap md5:pass]   deviceId: deviceID  sistema: @"ios" idioma: idioma version: version];
    
}

-(void)obtenerAnuncios{
//HE PUESTO FECHA INICIAL PARA QUE SIEMPRE SE TRAIGA TODOS
//        [service getAllBanner:self action:@selector(bannerHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] fechaUltComp:[[Util sharedInstance]dateForWS: [[Util sharedInstance] getDate:@"kpubli"]]];
    [service getAllBanner:self action:@selector(bannerHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] fechaUltComp:@"1981-04-09"];

    
}


-(void)editUsuarionuevopassword:(NSString *)nuevoP perfil:(Perfil *)p latitud:(float)lat longitud:(float)longitud {
    if([self checkConnectivity:NSLocalizedString(@"ws_perfil",nil) view:nil]){
        NSDictionary *subidas = [[Util sharedInstance]getFotosSubidas];
        //transformo diccionario de subidas en string
        NSMutableArray *arraySubidas =[NSMutableArray new];
        NSString *  esPrincipal =  [NSString stringWithFormat:@"b-%d",[p.fotoSeleccionada intValue] -1 ];
        for (NSString *key in [[subidas allKeys] sortedArrayUsingSelector:@selector(compare:)])
        {
            NSString *name =[subidas valueForKey:key];
            int valFoto =[[name substringFromIndex:(name.length-1)] intValue];
            if([p.fotoSeleccionada integerValue]-1 == valFoto)
            {
                int idx=[[key substringToIndex:0] intValue];
                esPrincipal =  [NSString stringWithFormat:@"s-%d",idx];
            }
            UIImage *imageCompress = [[Util sharedInstance] loadImagePerfil:name];
            NSString *img64 =[[Util sharedInstance] encodeImage:imageCompress];
            [arraySubidas addObject:img64];
        }
     
        NSString * stringSubidas =@"";
        if([arraySubidas count] == 1)
            stringSubidas = [arraySubidas objectAtIndex:0];
        else if([arraySubidas count]>1)
            stringSubidas = [arraySubidas componentsJoinedByString:@"***"];
        
        //transformo diccionario bajasdas en string
        NSMutableArray *bajadas= [[NSMutableArray alloc] initWithArray:[[Util sharedInstance] getFotosBajadas]];
        NSMutableArray *eliminadas= [[NSMutableArray alloc] initWithArray:[[Util sharedInstance] getFotosEliminadas]];
        [eliminadas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [bajadas removeObject:obj];
        }];
        NSString *stringBajadas= @"";
        if([bajadas count] == 1)
            stringBajadas = [bajadas objectAtIndex:0];
        else if([bajadas count] > 1)
            stringBajadas = [bajadas componentsJoinedByString:@"***"];
        
        //transformo principañ
      

        //envio
        [service editUsuario:self action:@selector(editarUsuarioHandler:) email:_emailAuxRegistro password: [Soap md5:_claveAuxRegistro] id:[p.idPerfil intValue ]idprovincia:[p.idProvincia intValue] nuevoemail:nil nuevopassword:nuevoP role:nil nombre:p.nombre edad:[p.edad intValue] provincia:nil latitud:lat longitud:longitud sexo:[p.sexo intValue] interesahombre:[p.interesahombre intValue] interesamujer:[p.interesamujer intValue] descripcion:p.descripcion esbot:-1 subidas:stringSubidas bajadas:stringBajadas esprincipal:esPrincipal];
    }
}

-(void)buscar:(Perfil *)perfil {
     if([self checkConnectivity:NSLocalizedString(@"ws_buscar",nil) view:nil]){
    	[service getAllUsuario:self action:@selector(getAllUsuarioHandler:) email: _emailAuxRegistro password: [Soap md5:_claveAuxRegistro] idusuario: [perfil.idPerfil intValue] latitud: [perfil.latitud doubleValue]  longitud: [perfil.longitud doubleValue] idprovincia: [[Util sharedInstance]provincia] radio: [[Util sharedInstance] getDistanciaMax]  edadmin: [[Util sharedInstance] rangoMin] edadmax: [[Util sharedInstance] rangoMax]];
     }
}

-(void)pedirClave:(NSString *)email{
     if([self checkConnectivity:NSLocalizedString(@"ws_clave",nil) view:nil]){
         [service recuperarPass:self action:@selector(pedirClaveHandler:) email:email];
     }
}

-(void)borrarPerfil:(Perfil *)perfil{
    if([self checkConnectivity:NSLocalizedString(@"ws_eliminar",nil) view:nil]){
        
        [service deleteUsuario:self action:@selector(borrarPerfilHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idUsuario:[perfil.idPerfil stringValue] ];
    }

}


-(void)editEncuentro:(int)myId envioAId:(int)idUser qimy:(int )qimyInt {
    NSString *keyText =@"ws_qimy";
    if(qimyInt==0)
        keyText =@"ws_noqimy";
    if([self checkConnectivity:NSLocalizedString(keyText,nil) view:nil]){
        [service editEncuentro:self action:@selector(editEncuentroHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idusuario1:myId idusuario2:idUser respuesta:qimyInt];
    }
    
}

-(void)editBloqueo:(int)myId envioAId:(int)idUser {
    if([self checkConnectivity:NSLocalizedString(@"ws_bloq",nil) view:nil]){
        [service editBloqueo:self action:@selector(editBloqueoHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro]  idbloqueante:myId idbloqueado:idUser];
    }
    
}
-(void)editDenuncia:(int)myId envioAId:(int)idUser {
    if([self checkConnectivity:NSLocalizedString(@"ws_den",nil) view:nil]){
        [service editPerfilfalso:self action:@selector(denunciaHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] iddenunciante:myId iddenunciado:idUser];
    }
}


-(void)getAllEncuentro:(int)myId{
    if([self checkConnectivity:NSLocalizedString(@"ws_enc",nil) view:nil]){
        [service getAllEncuentro:self action:@selector(getAllEncuentroHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idusuario:myId];
    }
}

-(void)getAllMessages:(int)myId envioAId:(int)idUser match:(int )match lastID:(int)lastId fechaUltima:(NSString * )fechaUltima{

    
    if([self checkConnectivity:NSLocalizedString(@"ws_chat",nil) view:nil]){
        [service getAllUltimosMensajes:self action:@selector(getAllUltimosMensajesHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idmatch:match lastId:lastId fechaUltComp:fechaUltima];
    }
}

-(void)getLastMessage:(int)idMatch {
    if([self checkConnectivity:NSLocalizedString(@"ws_msg",nil) view:nil]){
        [service getUltimoMensajeByIdMatch:self action:@selector(lastMessage:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idmatch:idMatch];
    }
}

-(void)editMessage:(int)myId envioAId:(int)idUser match:(int )idMatch fecha:(NSString *)fecha mensaje:(NSString *)mensaje{
    if([self checkConnectivity:NSLocalizedString(@"ws_envio_msg",nil) view:nil]){
        [service editMensaje:self action:@selector(editMessageHandler:) email:_emailAuxRegistro password:[Soap md5:_claveAuxRegistro] idemisor:myId idreceptor:idUser idmatch:idMatch fecha:fecha mensajetxt:mensaje];
    }
}

#pragma mark-handlers

-(void)userByIdHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    if(![self errorServer:value]){
        
        SDZUsuarioWS* result =  (SDZUsuarioWS*)value;
        _userInfo = @{@"resultado":@"OK"};
        [[BDServices sharedInstance] insertarUsuarios:@[result]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserid object:self userInfo    :_userInfo];
    }
}

-(void)editMessageHandler:(id)value{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"OK"] forKeys:@[@"resultado"]];
    int val = [value intValue];
    if(val == 1)
        [dic setValue:@"OK" forKey:@"resultado"];
    else if(val==0){
        [dic setValue:@"KO" forKey:@"resultado"];
    }
    [KVNProgress dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUltimoMensaje object:self userInfo:dic];
    
}

-(void)lastMessage:(id)value{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"OK",@"OK"] forKeys:@[@"resultado",@"denuncia"]];
    int val = [value intValue];
    if(val == 1)
        [dic setValue:@"OK" forKey:@"denuncia"];
    else if(val==-1){
        [dic setValue:@"KO" forKey:@"denuncia"];
    }
    [KVNProgress dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUltimoMensaje object:self userInfo:dic];
    
}


-(void)getAllEncuentroHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    if(![self errorServer:value]){
        
        SDZArrayOfEncuentro* result =  (SDZArrayOfEncuentro*)value;
        if([result.encuentros count]>0){
            _userInfo = @{@"resultado":@"OK"};
            [[BDServices sharedInstance] insertarEncuentros:result.encuentros];
        }else{
            [[BDServices sharedInstance] eliminarEncuentros:0];
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_error", nil) message:NSLocalizedString(@"alert_error_message", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil,nil] show];

        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEncuentros object:self userInfo    :_userInfo];

    
}

-(void)bannerHandler:(id)value{

    if(![self errorServer:value]){
        SDZArrayOfBanner* result =  (SDZArrayOfBanner*)value;
        [[BDServices sharedInstance] insertarPublicidad:result.banners];
        [[Util sharedInstance]updateDate:@"kpubli"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMuestraBusqueda object:self userInfo    :_userInfo];
}

-(void)getAllUltimosMensajesHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    if(![self errorServer:value]){
        
        SDZArrayOfMensaje* result =  (SDZArrayOfMensaje*)value;
                    _userInfo = @{@"resultado":@"OK"};
            [[BDServices sharedInstance] insertarMensajess:result.mensajes];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTodosMensajes object:_userInfo];

}


-(void)denunciaHandler:(id)value{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"OK",@"OK"] forKeys:@[@"resultado",@"denuncia"]];
    int val = [value intValue];
    if(val == 1)
        [dic setValue:@"OK" forKey:@"denuncia"];
    else if(val==-1){
        [dic setValue:@"KO" forKey:@"denuncia"];
    }
    [KVNProgress dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDenuncia object:self userInfo:dic];
    
}


-(void)editBloqueoHandler:(id)value{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"OK",@"OK"] forKeys:@[@"resultado",@"bloqueo"]];
    int val = [value intValue];
    if(val == 1)
        [dic setValue:@"OK" forKey:@"bloqueo"];
    else if(val==-1){
        [dic setValue:@"KO" forKey:@"bloqueo"];
    }
    [KVNProgress dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBloqueo object:self userInfo:dic];
    
}


-(void)editEncuentroHandler:(id)value{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@"OK",@"OK"] forKeys:@[@"resultado",@"qimy"]];
    int val = [value intValue];
    if(val == 1)
        [dic setValue:@"OK" forKey:@"qimy"];
    else if(val==0){
        [dic setValue:@"KO" forKey:@"qimy"];
    }
    [KVNProgress dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationQimy object:self userInfo:dic];
    
}


-(void)borrarPerfilHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    NSNumber *result = (NSNumber *)value;
    int val = [result intValue];
    if(val == 1)
        _userInfo = @{@"resultado":@"OK"};
    else {
        _userInfo = @{@"resultado":@"KO"};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBorrarPerfil object:self userInfo:_userInfo];
    
}


-(void)pedirClaveHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    NSNumber *result = (NSNumber *)value;
    int val = [result intValue];
    if(val == 1)
        _userInfo = @{@"resultado":@"OK"};
    else {
        _userInfo = @{@"resultado":@"KO"};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecuperaClave object:self userInfo:_userInfo];

}

-(void)getAllUsuarioHandler:(id)value{
    _userInfo = @{@"resultado":@"KO"};
    if(![self errorServerNoHUD:value]){
        
        SDZArrayOfUsuario* result =  (SDZArrayOfUsuario*)value;
        if([result.usuarios count]>0){
            _userInfo = @{@"resultado":@"OK"};
            [[BDServices sharedInstance] insertarUsuarios:result.usuarios];
            [self obtenerAnuncios];
        }else{
            [KVNProgress dismiss];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_error", nil) message:NSLocalizedString(@"alert_error_message", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil,nil] show];

        }
    }
}

-(void)editarUsuarioHandler:(id)value{
    if(![self errorServer:value]){
        SDZUsuarioWS* result =  (SDZUsuarioWS*)value;
        if(result.password != nil){
            [[BDServices sharedInstance] insertarPerfil:result];
            _userInfo = @{@"resultado":@"OK"};
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPerfilOK object:self userInfo:_userInfo];
            [KVNProgress showSuccess];
            [KVNProgress dismiss];
        }else{
            _userInfo = @{@"resultado":@"KO"};
            [KVNProgress showError];
            [KVNProgress dismiss];
        }
    }
}

-(void)registrarDispositivoHandler:(id)value{
    
   
    NSNumber *result = (NSNumber *)value;
        int val = [result intValue];
        NSLog(@"registro returned the value: %d", val);
        if(val == 1){
            NSLog(@"OK, notif");
        }
        else {
            [KVNProgress showError];
            [KVNProgress dismiss];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notif_error_title", nil) message:NSLocalizedString(@"notif_error_mess", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        [self getProvincias];
  

}

-(void)provinciasHandler:(id)value{
    if(![self errorServerNoHUD:value]){
        SDZArrayOfProvincia* result =  (SDZArrayOfProvincia*)value;
        [[BDServices sharedInstance] insertarProvincias:result.provincias];
    }else{
        [KVNProgress showError];
        [KVNProgress dismiss];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserOK object:self userInfo:_userInfo];


    
}

- (void) loginHandler: (id) value {
    if(![self errorServer:value]){
        SDZUsuarioWS* result =  (SDZUsuarioWS*)value;
        if(result.activo == 1){
           
            [[BDServices sharedInstance] insertarPerfil:result];
            _userInfo = @{@"resultado":@"OK"};
            [self registrarDispositivo:_emailAuxRegistro pass:_claveAuxRegistro];
        }else{
            _userInfo = @{@"resultado":@"KO"};
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [KVNProgress showError];
            [KVNProgress dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserOK object:self userInfo:_userInfo];
        }
    }
}

- (void) registroHandler: (id) value {
    NSNumber *result = (NSNumber *)value;
    int val = [result intValue];
    NSLog(@"registro returned the value: %d", val);
    NSDictionary *resultNotif = @{@"resultado":result};
    if(val == 1)
        [KVNProgress showSuccess];
    else if(val==-1){
        [KVNProgress dismiss];

            double latit= [[[[Util sharedInstance]localiza] objectAtIndex:1] doubleValue] ;
            double longitud = [[[[Util sharedInstance]localiza] objectAtIndex:0] doubleValue] ;

        [self login:_emailAuxRegistro pass:_claveAuxRegistro view:nil :longitud :latit];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegistroOK object:self userInfo:resultNotif];
}

#pragma mark -facebook


//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    if(self.controlFacebookDelegate == 0){
//        self.controlFacebookDelegate = 1;
//
//        NSString *username = user.first_name;
//        NSString *password = [UPPCUtil md5:[NSString stringWithFormat:@"%@UPPC",username]];
//        self.facebookData = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             @"username", username,
//                             @"password", password,
//                             nil];
//        [self.service comprobarUsuarioFBAsync:username password:password __target:self __handler:@selector(comprobarUsuarioFBHandler:)];
//    }
//}

//- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
//    NSString *alertMessage, *alertTitle;
//
//    // If the user should perform an action outside of you app to recover,
//    // the SDK will provide a message for the user, you just need to surface it.
//    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
//    if ([FBErrorUtility shouldNotifyUserForError:error]) {
//        alertTitle = kFacebook_error1;
//        alertMessage = [FBErrorUtility userMessageForError:error];
//
//        // This code will handle session closures that happen outside of the app
//        // You can take a look at our error handling guide to know more about it
//        // https://developers.facebook.com/docs/ios/errors
//    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
//        alertTitle = kFacebook_error2;
//        alertMessage = kFacebook_message1;
//
//        // If the user has cancelled a login, we will do nothing.
//        // You can also choose to show the user a message if cancelling login will result in
//        // the user not being able to complete a task they had initiated in your app
//        // (like accessing FB-stored information or posting to Facebook)
//    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//        NSLog(@"user cancelled login");
//
//        // For simplicity, this sample handles other errors with a generic message
//        // You can checkout our error handling guide for more detailed information
//        // https://developers.facebook.com/docs/ios/errors
//    } else {
//        alertTitle  = kFacebook_error3;
//        alertMessage = kFacebook_message2;
//        NSLog(@"Unexpected error:%@", error);
//    }
//
//    if (alertMessage) {
//        [UPPCUtil showDefaultContentView:alertMessage];
//    }
//}
//
//- (void)comprobarUsuarioFBHandler:(id)value{
//#warning TODO: ESTE ERROR SIGUE SIN RESOLVERSE
//#ifdef DEBUG
//    NSLog(@"comprobarUsuarioFacebook returned the value: %@", value);
//#endif
//}



#pragma mark-errores

-(BOOL)checkConnectivity:(NSString *)message view:(UIView *)view{
    
    if ([FXReachability isReachable]){
        [KVNProgress dismiss];
        [KVNProgress showWithStatus:message];
        return true;
    }
    else{
        [Util showDefaultContentView:  NSLocalizedString(@"ws_error_connect", nil)];
        return false;
    }
}


-(BOOL)errorServer:(id)value{
    // Handle errors
    [KVNProgress dismiss];
    if([value isKindOfClass:[NSError class]]) {
        [Util showDefaultContentView: NSLocalizedString(@"ws_error", nil)];
        return true;
    }
    
    return false;
    
}

-(BOOL)errorServerNoHUD:(id)value{
    // Handle errors
    if([value isKindOfClass:[NSError class]]) {
        [Util showDefaultContentView:  NSLocalizedString(@"ws_error", nil)];
        return true;
    }
    return false;
}


-(void)showHUDmessage:(NSString *)message{
    [KVNProgress show];
    //   [self.HUD showInView:self.currentViewForHUD];
}

@end
