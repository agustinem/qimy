/*
	SDZWsclassService.h
	The interface definition of classes and methods for the WsclassService web service.
	Generated by SudzC.com
*/
				
#import "Soap.h"
	
/* Add class references */
				
#import "SDZArrayOfBannerws.h"
#import "SDZArrayOfBanner.h"
#import "SDZArrayOfBloqueows.h"
#import "SDZArrayOfBloqueo.h"
#import "SDZArrayOfEncuentrows.h"
#import "SDZArrayOfEncuentro.h"
#import "SDZArrayOfMensajews.h"
#import "SDZArrayOfMensaje.h"
#import "SDZArrayOfPerfilfalsows.h"
#import "SDZArrayOfPerfilfalso.h"
#import "SDZArrayOfString.h"
#import "SDZArrayOfUsuariows.h"
#import "SDZArrayOfUsuario.h"
#import "SDZArrayOfProvinciaws.h"
#import "SDZArrayOfProvincia.h"
#import "SDZUsuarioWS.h"
#import "SDZBloqueoWS.h"
#import "SDZPerfilfalsoWS.h"
#import "SDZBannerWS.h"
#import "SDZProvinciaWS.h"
#import "SDZMensajeWS.h"
#import "SDZEncuentroWS.h"

/* Interface for the service */
				
@interface SDZWsclassService : SoapService
		
	// Returns SDZUsuarioWS*
	/*  */
	-(SoapRequest*)login:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password latitud: (double) latitud longitud: (double) longitud;
	-(SoapRequest*)login:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password latitud: (double) latitud longitud: (double) longitud;
	-(SoapRequest*)loginWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password latitud: (double) latitud longitud: (double) longitud completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)recuperarPass:(id<SoapDelegate>)handler email: (NSString*) email;
	-(SoapRequest*)recuperarPass:(id)target action:(SEL)action email: (NSString*) email;
	-(SoapRequest*)recuperarPassWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)registro:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password;
	-(SoapRequest*)registro:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password;
	-(SoapRequest*)registroWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZArrayOfBanner*
	/*  */
	-(SoapRequest*)getAllBanner:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password fechaUltComp: (NSString*) fechaUltComp;
	-(SoapRequest*)getAllBanner:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password fechaUltComp: (NSString*) fechaUltComp;
	-(SoapRequest*)getAllBannerWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password fechaUltComp: (NSString*) fechaUltComp completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)editBloqueo:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idbloqueante: (int) idbloqueante idbloqueado: (int) idbloqueado;
	-(SoapRequest*)editBloqueo:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idbloqueante: (int) idbloqueante idbloqueado: (int) idbloqueado;
	-(SoapRequest*)editBloqueoWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idbloqueante: (int) idbloqueante idbloqueado: (int) idbloqueado completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZArrayOfEncuentro*
	/*  */
	-(SoapRequest*)getAllEncuentro:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario;
	-(SoapRequest*)getAllEncuentro:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario;
	-(SoapRequest*)getAllEncuentroWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)editEncuentro:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idusuario1: (int) idusuario1 idusuario2: (int) idusuario2 respuesta: (int) respuesta;
	-(SoapRequest*)editEncuentro:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idusuario1: (int) idusuario1 idusuario2: (int) idusuario2 respuesta: (int) respuesta;
	-(SoapRequest*)editEncuentroWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idusuario1: (int) idusuario1 idusuario2: (int) idusuario2 respuesta: (int) respuesta completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)editMensaje:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idemisor: (int) idemisor idreceptor: (int) idreceptor idmatch: (int) idmatch fecha: (NSString*) fecha mensajetxt: (NSString*) mensajetxt;
	-(SoapRequest*)editMensaje:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idemisor: (int) idemisor idreceptor: (int) idreceptor idmatch: (int) idmatch fecha: (NSString*) fecha mensajetxt: (NSString*) mensajetxt;
	-(SoapRequest*)editMensajeWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idemisor: (int) idemisor idreceptor: (int) idreceptor idmatch: (int) idmatch fecha: (NSString*) fecha mensajetxt: (NSString*) mensajetxt completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZArrayOfMensaje*
	/*  */
	-(SoapRequest*)getAllUltimosMensajes:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch lastId: (int) lastId fechaUltComp: (NSString*) fechaUltComp;
	-(SoapRequest*)getAllUltimosMensajes:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch lastId: (int) lastId fechaUltComp: (NSString*) fechaUltComp;
	-(SoapRequest*)getAllUltimosMensajesWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch lastId: (int) lastId fechaUltComp: (NSString*) fechaUltComp completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZMensajeWS*
	/*  */
	-(SoapRequest*)getUltimoMensajeByIdMatch:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch;
	-(SoapRequest*)getUltimoMensajeByIdMatch:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch;
	-(SoapRequest*)getUltimoMensajeByIdMatchWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idmatch: (int) idmatch completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)editPerfilfalso:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password iddenunciante: (int) iddenunciante iddenunciado: (int) iddenunciado;
	-(SoapRequest*)editPerfilfalso:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password iddenunciante: (int) iddenunciante iddenunciado: (int) iddenunciado;
	-(SoapRequest*)editPerfilfalsoWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password iddenunciante: (int) iddenunciante iddenunciado: (int) iddenunciado completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZArrayOfUsuario*
	/*  */
	-(SoapRequest*)getAllUsuario:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario latitud: (double) latitud longitud: (double) longitud idprovincia: (int) idprovincia radio: (double) radio edadmin: (int) edadmin edadmax: (int) edadmax;
	-(SoapRequest*)getAllUsuario:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario latitud: (double) latitud longitud: (double) longitud idprovincia: (int) idprovincia radio: (double) radio edadmin: (int) edadmin edadmax: (int) edadmax;
	-(SoapRequest*)getAllUsuarioWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idusuario: (int) idusuario latitud: (double) latitud longitud: (double) longitud idprovincia: (int) idprovincia radio: (double) radio edadmin: (int) edadmin edadmax: (int) edadmax completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZUsuarioWS*
	/*  */
	-(SoapRequest*)getUsuarioById:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idUsuario: (int) idUsuario;
	-(SoapRequest*)getUsuarioById:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idUsuario: (int) idUsuario;
	-(SoapRequest*)getUsuarioByIdWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idUsuario: (int) idUsuario completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZUsuarioWS*
	/*  */
	-(SoapRequest*)editUsuario:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password id: (int) _id idprovincia: (int) idprovincia nuevoemail: (NSString*) nuevoemail nuevopassword: (NSString*) nuevopassword role: (NSString*) role nombre: (NSString*) nombre edad: (int) edad provincia: (NSString*) provincia latitud: (float) latitud longitud: (float) longitud sexo: (int) sexo interesahombre: (int) interesahombre interesamujer: (int) interesamujer descripcion: (NSString*) descripcion esbot: (int) esbot subidas: (NSString*) subidas bajadas: (NSString*) bajadas esprincipal: (NSString*) esprincipal;
	-(SoapRequest*)editUsuario:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password id: (int) _id idprovincia: (int) idprovincia nuevoemail: (NSString*) nuevoemail nuevopassword: (NSString*) nuevopassword role: (NSString*) role nombre: (NSString*) nombre edad: (int) edad provincia: (NSString*) provincia latitud: (float) latitud longitud: (float) longitud sexo: (int) sexo interesahombre: (int) interesahombre interesamujer: (int) interesamujer descripcion: (NSString*) descripcion esbot: (int) esbot subidas: (NSString*) subidas bajadas: (NSString*) bajadas esprincipal: (NSString*) esprincipal;
	-(SoapRequest*)editUsuarioWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password id: (int) _id idprovincia: (int) idprovincia nuevoemail: (NSString*) nuevoemail nuevopassword: (NSString*) nuevopassword role: (NSString*) role nombre: (NSString*) nombre edad: (int) edad provincia: (NSString*) provincia latitud: (float) latitud longitud: (float) longitud sexo: (int) sexo interesahombre: (int) interesahombre interesamujer: (int) interesamujer descripcion: (NSString*) descripcion esbot: (int) esbot subidas: (NSString*) subidas bajadas: (NSString*) bajadas esprincipal: (NSString*) esprincipal completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/*  */
	-(SoapRequest*)deleteUsuario:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password idUsuario: (NSString*) idUsuario;
	-(SoapRequest*)deleteUsuario:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password idUsuario: (NSString*) idUsuario;
	-(SoapRequest*)deleteUsuarioWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password idUsuario: (NSString*) idUsuario completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns int
	/* Datos necesarios para enviar notificacion
			 */
	-(SoapRequest*)registrarDispositivo:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password deviceId: (NSString*) deviceId sistema: (NSString*) sistema idioma: (NSString*) idioma version: (NSString*) version;
	-(SoapRequest*)registrarDispositivo:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password deviceId: (NSString*) deviceId sistema: (NSString*) sistema idioma: (NSString*) idioma version: (NSString*) version;
	-(SoapRequest*)registrarDispositivoWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password deviceId: (NSString*) deviceId sistema: (NSString*) sistema idioma: (NSString*) idioma version: (NSString*) version completion:(SoapRequestCompletionBlock)completionBlock;

	// Returns SDZArrayOfProvincia*
	/*  */
	-(SoapRequest*)getAllProvincia:(id<SoapDelegate>)handler email: (NSString*) email password: (NSString*) password;
	-(SoapRequest*)getAllProvincia:(id)target action:(SEL)action email: (NSString*) email password: (NSString*) password;
	-(SoapRequest*)getAllProvinciaWithProgress:(SoapRequestProgressBlock)progressBlock email: (NSString*) email password: (NSString*) password completion:(SoapRequestCompletionBlock)completionBlock;

		
	+ (SDZWsclassService*) service;
	+ (SDZWsclassService*) serviceWithUsername: (NSString*) username andPassword: (NSString*) password;
@end
	