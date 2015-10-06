//
//  Constants.h
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface Constants : NSObject


extern NSString * const URLWEB;
extern NSString * const URLBANNER;
extern NSString * const URLWS;
extern NSString * const URLImages;
extern NSString * const kBDDateFormat;

extern NSString * const kNotificationProvincias;
extern NSString * const kNotificationUserOK;
extern NSString * const kNotificationPerfilOK;
extern NSString * const kNotificationRegistroOK;
extern NSString * const kNotificationChangeFoto;
extern NSString * const kNotificationMuestraBusqueda;
extern NSString * const kNotificationRecuperaClave;
extern NSString * const kRegistorDispositivo;
extern NSString * const kNotificationBorrarPerfil;

extern NSString * const kNotificationQimy;
extern NSString * const kNotificationBloqueo;
extern NSString * const kNotificationDenuncia;
extern NSString * const kNotificationChat;
extern NSString * const kNotificationAdelante;

extern NSString * const kNotificationEditMensaje;
extern NSString * const kNotificationUltimoMensaje;
extern NSString * const kNotificationEncuentros;
extern NSString * const kNotificationTodosMensajes;

extern NSString * const kNotificationFichaChat;
extern NSString * const kNotificationUserid;

@end
