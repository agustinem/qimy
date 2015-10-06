//
//  Util.h
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class Perfil;
#import "UPPCAlertView.h"

@interface Util : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>



+(Util *)sharedInstance;

+(NSString *)getVersion;

+(NSString *)getLengua;



+ (bool)firstLogin;
+(void)perfilOK;
+ (bool)isPerfilOK;

+ (void)closeSession;

+(bool)validar:(Perfil *)p;
+ (CGFloat)screenWidth;
/**
 *  Save Date with BDFormt in local memory
 KDATE is TYpe of Date to Update
 */
-(void)updateDate:(NSString *)kDate;
-(NSString *)dateForWS:(NSDate *)date;
/**
 *  get Date in DB Format
 KDATE is TYpe of Date to last time to access (type kDestiny, kExperience...)
 *  @return Date in string
 */
-(NSDate *)getDate:(NSString *)kDate;

/**
 *  Transform native nsdate to fromat bd
 *
 *  @param date date to format
 *
 *  @return format date
 */
-(NSDate *)dateFormat:(NSDate *)date;

-(NSDate *)dateFormatWS:(NSString *)dateString;
/**
 *  Move two Views: from and to from their actual positions to the positon pass by params.Normallity we use this method for transition between views from - to. From dissapera and to Appear
 *
 *  @param from uiview what normality appear in scene
 *  @param to   uiview what normality disappear in scene
 *  @param x    move axis-x of viewfrom
 *  @param xTo  move axis-f of viewTo
 */
+(void)moveViewFrom:(UIView *) from viewTo:(UIView *)to fromX:(int)x toX:(int)xTo;

/**
 *  Show alert message
 *
 *  @param text text of message
 */
+ (void)showDefaultContentView:(NSString *)text;

/**
 *  Return AlertView
 *
 *  @param text text
 *
 *  @return we can use handler when dismiss
 */
+ (UPPCAlertView *)showDefaultContentViewHandler:(NSString *)text;
/**
 *  Save Login in local memory
 *
 *  @param login True if user is login sometime
 */
+ (void) saveUserLoginUser:(NSString *)username pass:(NSString *)password;

/**
 *  Return if user is login sometime
 *
 *  @return true if user has been logged sometime.
 */
+ (BOOL) isUserLogin:(NSString *)username pass:(NSString *)password;

/**
 *  Save images
 *
 *  @param imageURL  url image to save
 *  @param namePhoto name IMage to save
 *  @param folder    folder image
 */
-(void)saveImage:(NSString *)imageURL name:(NSString *)namePhoto folder:(NSString *)folder;

/**
 *  load image to local
 *
 *  @param namePhoto name photo
 *  @param folder    folder
 *  @param url    url image in web
 *
 *  @return image
 */
-(UIImage *)imageLoad:(NSString *)namePhoto folder:(NSString *)folder url:(NSString *)url;

/**
 *  MD5
 *
 *  @param value MD5
 *
 *  @return MD5
 */
+(NSString*)md5:(NSString*)value;

/**
 *  Save Slider ONCE FOR DAY
 */
-(void)savePhotosSlider;

//Check if image exists.
-(bool)existsImage:(NSString *)namePhoto folder:(NSString *)folder;


//Use for make differents names photo depending of type (listado, ...)
-(NSString *)name:(NSString *)name type:(NSString *)type;

/**
 *  Compare lastDate with now if difference is better than parameter time returns true
 *
 *  @param time     time for compare
 *  @param lastDate last date
 *
 *  @return true if (last date is better that time
 */
-(BOOL)compareTimeNow:(NSInteger)time lastDate:(NSDate *) lastDate;



- (void)zoomToFitMapAnnotations:(MKMapView *)mapView ;

- (void)zoomToFitMapAnnotationsAndUser:(MKMapView *)mapView;

-(void)removeMapAnnotations:(MKMapView *)myMap;

/**
 *  Start localization service
 *
 *  @param view view for HUD
 */
- (void)startStandardUpdates:(UIView *)view;

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *imagew))completionBlock;

-(void)changeImageFade:(UIImageView *)imageView :(UIImage *)imageNew;

-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to;

-(void)getUserLoc:(UIView *)view;

+ (UIColor *)colorFromHexString:(NSString *)hexString ;

-(UIImage *)loadImagePerfil:(NSString *)nombre;

- (void)removeImage:(NSString*)fileName ;

- (void)saveImgePerfil:(NSString *)nombre image:(UIImage *)original scale:(CGFloat)scale;

-(void)saveNameFotos:(NSString *)nombre;

-(UIImage *)decodeImage:(NSString *)image64;
    
-(NSString *)encodeImage:(UIImage *)image;

-(NSArray *)getFotosBajadas;

-(void)saveFotosBajadas:(NSArray *)fotos;


-(void)saveFotosEliminadas:(NSArray *)fotos;

-(NSArray *)getFotosEliminadas;

-(NSString *)getFotoPpal;

-(void)saveNombreFotoPrincipal:(NSString *)fotoP;

-(void)saveFotosSubidas:(NSDictionary *)dic;

-(NSDictionary *)getFotosSubidas;

- (void)requestAlwaysAuthorization;

-(void)isGeolo:(bool)isgeolo;

-(bool)isGeolo;

-(float)rangoMax;

-(void)rangoMin:(float)rmin;

-(float)rangoMin;

-(void)provinciaBusco:(float)idProv;

-(float)provincia;

-(void)rangoMax:(float)rmax;
-(void)distanciaMax:(float)distancia;

-(float)getDistanciaMax;

-(NSArray *)localiza;

-(void)localiza:(NSArray *)valores;

-(bool)loginByFB;

-(void)loginByFB:(bool )valor;

-(UILabel *)editarTitulo:(NSString *)texto nombre:(NSString *)textoNombre label:(UILabel *)label;

-(void)guarda:(NSString *)clave :(NSString *)valor;

-(id)carga:(NSString *)clave;

-(void)indexLocal:(float)index;

-(float)indexLocal;

@end
