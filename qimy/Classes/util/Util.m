//
//  Util.m
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "Util.h"
#import "Perfil.h"
#import <CommonCrypto/CommonDigest.h>
#import "FXReachability.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UPPCAlertView.h"
#import <CXCardView/CXCardView.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <KVNProgress/KVNProgress.h>
#import "Soap.h"
#import "BDServices.h"
@interface Util()

@property CLLocationManager *locationManager;

@end

@implementation Util

+(Util *)sharedInstance{
    
    static Util *new = nil;
    if(new== nil)
        new = [Util new];
    return new;
}

+ (CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;

}

+(NSString *)getVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)getLengua{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}


-(NSDate *)getDate:(NSString *)kDate{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kDate];
    if(date==nil){
        date = [NSDate dateWithTimeIntervalSince1970:0];
    }
//            date = [NSDate dateWithTimeIntervalSince1970:0];
    return date;
}

-(void)updateDate:(NSString *)kDate{
    NSDate *dateNow = [NSDate date];
    [[NSUserDefaults standardUserDefaults]  setObject:dateNow forKey:kDate];
}

-(NSString *)dateForWS:(NSDate *)date{
    if(!date) date = [NSDate date];    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = kBDDateFormat;
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    dateFormat.timeZone = tz;
    return  [dateFormat stringFromDate:date];
}

-(NSDate *)dateFormatWS:(NSString *)dateString{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = kBDDateFormat;
    return [dateFormat dateFromString:dateString];
}



-(BOOL)compareTimeNow:(NSInteger)time lastDate:(NSDate *) lastDate{
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
    if (timeNow - lastTime > time*3600) {
        return true;
    }
    return false;
}

#pragma mark - navigation into view

+(void)moveViewFrom:(UIView *) from viewTo:(UIView *)to fromX:(int)x toX:(int)xTo {
    [UIView animateWithDuration:0.4f animations:^{
        from.frame = CGRectMake(x, 0, from.frame.size.width, from.frame.size.height);
        to.frame = CGRectMake(xTo, 0, to.frame.size.width, to.frame.size.height);
        
    }];
}

#pragma mark - Errors Alert

+ (void)showDefaultContentView:(NSString *)text
{
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
//    UPPCAlertView * _firstContentView = [UPPCAlertView defaultView];
//    
//    UILabel *descriptionLabel = [[UILabel alloc] init];
//    if(IS_IPHONE_6P)
//        descriptionLabel.frame = CGRectMake([Util screenWidth] *0.1 +20, 0, [Util screenWidth] *0.8 -40, 150);
//    else
//        descriptionLabel.frame = CGRectMake(20, 0, [Util screenWidth] *0.8 -40, 150);        
//    descriptionLabel.numberOfLines = 0.;
//    descriptionLabel.textAlignment = NSTextAlignmentLeft;
//    descriptionLabel.backgroundColor = [UIColor clearColor];
//    descriptionLabel.textColor = [UIColor blackColor];
//    descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14.];
//    descriptionLabel.text = text;
//    [_firstContentView addSubview:descriptionLabel];
//    
//    [_firstContentView setDismissHandler:^(UPPCAlertView *view) {
//        // to dismiss current cardView. Also you could call the `dismiss` method.
//        [CXCardView dismissCurrent];
//    }];
//    [CXCardView showWithView:_firstContentView draggable:YES];
}

+ (UPPCAlertView *)showDefaultContentViewHandler:(NSString *)text
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    return nil;
//    UPPCAlertView * _firstContentView = [UPPCAlertView defaultView];
//    UILabel *descriptionLabel = [[UILabel alloc] init];
//    descriptionLabel.frame = CGRectMake(20, 8, 260, 100);
//    descriptionLabel.numberOfLines = 0.;
//    descriptionLabel.textAlignment = NSTextAlignmentLeft;
//    descriptionLabel.backgroundColor = [UIColor clearColor];
//    descriptionLabel.textColor = [UIColor blackColor];
//    descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14.];
//    descriptionLabel.text = text;
//    [_firstContentView addSubview:descriptionLabel];
//    [CXCardView showWithView:_firstContentView draggable:YES];
//    return _firstContentView;
}


#pragma mark - NSUSersDefaults components


+ (void) saveUserLoginUser:(NSString *)username pass:(NSString *)password{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:username forKey:@"usuarioLogin"];
    [prefs setObject:password forKey:@"passwordLogin"];
}

+ (BOOL) isUserLogin:(NSString *)username pass:(NSString *)password{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * user = [prefs objectForKey:@"usuarioLogin"];
    NSString * pass = [prefs objectForKey:@"passwordLogin"];
    if([username isEqualToString:user] && [password isEqualToString:pass] && ![user isEqualToString:@""])
        return true;
    else
        return false;
}

+ (bool)firstLogin{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool result = [prefs boolForKey:@"isLogin"];
    if(result)
        return false;
    else{
        [prefs setBool:true forKey:@"isLogin"];
        return true;
    }
}


+(void)perfilOK{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:true forKey:@"isPerfilOk"];

}


+ (bool)isPerfilOK{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:@"isPerfilOk"];
}

+(bool)validar:(Perfil *)p{
    NSString *error = @"";
    if ([p.nombre length] <=0) {
        error = [error stringByAppendingString:(NSLocalizedString(@"validar_perfilnombre", nil))];
    }
    if ([p.edad intValue]==0) {
        error = [error stringByAppendingString:(NSLocalizedString(@"validar_perfiledad", nil))];
    }
    if ([p.descripcion length] <=0) {
        error = [error stringByAppendingString:(NSLocalizedString(@"validar_perfildescrip", nil))];
    }
    if ([p.idProvincia intValue] == 0) {
        error = [error stringByAppendingString:(NSLocalizedString(@"validar_perfilprovincia", nil))];
    }
    if ( [p.fotoSeleccionada intValue]< 1)   {
        error = [error stringByAppendingString:(NSLocalizedString(@"validar_perfilcarita", nil))];
    }
    if([error length]>0){
        [[[UIAlertView alloc] initWithTitle:(NSLocalizedString(@"validar_alert", nil)) message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return false;
    }
    return true;
}


+ (void)closeSession{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"usuarioLogin"];
    [prefs setObject:@"" forKey:@"passwordLogin"];
    [prefs setBool:false forKey:@"isLogin"];
    [prefs setFloat:25 forKey:@"distanciaMax"];
    [prefs setFloat:25 forKey:@"rangoMin"];
    [prefs setFloat:50 forKey:@"rangoMax"];
    [prefs setBool:false forKey:@"loginByFB"];
    [prefs setBool:false forKey:@"isPerfilOk"];
    [prefs setFloat:0 forKey:@"provinciaBuscar"];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[BDServices sharedInstance] eliminarPerfil];
    for(int i=0; i<5; i++){
        NSString *nombre = [NSString stringWithFormat:@"imageLocal%d",i];
        [[Util sharedInstance] removeImage:nombre];
    }
    //TODO:ELIMINAR TODOS LOS DATOS
}

#pragma-mark IMAGES

-(bool)existsImage:(NSString *)namePhoto folder:(NSString *)folder{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
    {
        return false;
    }
    path = [path stringByAppendingPathComponent:namePhoto];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does file already exist?
    {
        return false;
    }
    return true;
}


-(void)saveImage:(NSString *)imageURL name:(NSString *)namePhoto folder:(NSString *)folder{
    if ([FXReachability isReachable] && imageURL!=nil){
        NSString *path;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {
                NSLog(@"Create directory error: %@", error);
            }
        }
        path = [path stringByAppendingPathComponent:namePhoto];
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        if(data!=nil){
            UIImage * imageSave = [[UIImage alloc] initWithData:data];
            NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(imageSave, 1)];
            [data1 writeToFile:path atomically:YES];
#ifdef DEBUG
            NSLog(@"saving image done %@",namePhoto);
#endif
        }
    }
}

//
//-(UIImage *)imageLoad:(NSString *)namePhoto folder:(NSString *)folder url:(NSString *)url{
//    //image while Waiting load real image
//    UIImage *image = [UIImage imageNamed:@"noImage_sugerido"];
//    if ([namePhoto rangeOfString:@"slider"].location != NSNotFound)
//        image = [UIImage imageNamed:@"home_header"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
//	path = [path stringByAppendingPathComponent:namePhoto];
//	if ([[NSFileManager defaultManager] fileExistsAtPath:path])	{
//        //if exists return image
//        image = [UIImage imageWithContentsOfFile:path];
//        return image;
//    }else if(url!=nil){
//        image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//        if(image == nil)
//            //if no exists return no Image
//            image = [UIImage imageNamed:@"noImage_sugerido"];
//        else{
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//                if(![[UPPCUtil sharedInstance]existsImage:namePhoto folder:kExperienceFolder])
//                {
//                    [self saveImage:url name:namePhoto folder:kExperienceFolder];
//                }
//            });
//        }
//    }
//    return image;
//}

-(UIImage *)imageLoad:(NSString *)namePhoto folder:(NSString *)folder url:(NSString *)url{
    //image while Waiting load real image
    UIImage *image = nil;
    if ([namePhoto rangeOfString:@"slider"].location != NSNotFound)
        image = [UIImage imageNamed:@"home_header"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
    path = [path stringByAppendingPathComponent:namePhoto];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])	{
        //if exists return image
        image = [UIImage imageWithContentsOfFile:path];
        return image;
    }else{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            if(![[Util sharedInstance]existsImage:namePhoto folder:folder])
            {
                [self saveImage:url name:namePhoto folder:folder];
            }
        });
    }
    
    return image;
}


-(void)changeImageFade:(UIImageView *)imageView :(UIImage *)imageNew{
    [UIView transitionWithView:imageView
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imageView.image = imageNew;
                    } completion:nil];
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *imagew))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *imagew = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,imagew);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(void)savePhotosSlider{
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(savePhotos:)
                                                   object:nil];
    [myThread start];
}

-(void)savePhotos:(NSThread *)thread{
    
    NSString *nameUrl;
    NSString *nameFile;
    for (int i=1; i<6; i++) {
        nameUrl = [NSString stringWithFormat:@"%@/slider%d.jpg",URLImages,i];
        nameFile = [NSString stringWithFormat:@"slider%d.jpg",i];
        if ([FXReachability isReachable] ){
            NSString *path;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slider"];
            NSError *error;
            if (![[NSFileManager defaultManager] fileExistsAtPath:path])	//Does directory already exist?
            {
                if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                               withIntermediateDirectories:NO
                                                                attributes:nil
                                                                     error:&error])
                {
                    NSLog(@"Create directory error: %@", error);
                }
            }
            
            NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:nameUrl]];
            if(data!=nil){
                UIImage * imageSave = [[UIImage alloc] initWithData:data];
                NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(imageSave, 1.0)];
                path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"slider"];
                path = [path stringByAppendingPathComponent:nameFile];
                [data1 writeToFile:path atomically:YES];
#ifdef DEBUG
                NSLog(@"saving slider image done");
#endif
            }
            
        }
        
    }
    [[Util sharedInstance] updateDate:@"fechaApp"];
}

-(NSString *)name:(NSString *)name type:(NSString *)type{
    NSArray *arrayName = [name componentsSeparatedByString:@"_"];
    
    NSString *result=arrayName[0];
    for(int i = 1; i<[arrayName count];i++)
    {
        if(i == [arrayName count]-1)
            result = [NSString stringWithFormat:@"%@_%@.jpg",result,type];
        else{
            
            result =  [NSString stringWithFormat:@"%@_%@",result,arrayName[i]];
        }
    }
    return result;
}




#pragma mark MAP UTILS

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
    
    region = [mapView regionThatFits:region];
    
    [mapView setRegion:region animated:YES];
}


- (void)zoomToFitMapAnnotationsAndUser:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    CLLocationCoordinate2D userCoordinate = mapView.userLocation.location.coordinate;
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    topLeftCoord.longitude = fmin(topLeftCoord.longitude, userCoordinate.longitude);
    topLeftCoord.latitude = fmax(topLeftCoord.latitude, userCoordinate.latitude);
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, userCoordinate.longitude);
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, userCoordinate.latitude);
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
    
    region = [mapView regionThatFits:region];
    
    [mapView setRegion:region animated:YES];
}


#pragma mark ENCODE UTILS

+(NSString*)md5:(NSString*)value{
    const char *cStr = [value UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - Keyboard
-(void)removeMapAnnotations:(MKMapView *)myMap{
    NSInteger toRemoveCount = myMap.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in myMap.annotations)
        if (annotation != myMap.userLocation)
            [toRemove addObject:annotation];
    [myMap removeAnnotations:toRemove];
}

#pragma mark - Locations
- (void)startStandardUpdates:(UIView *)view
{
    [self requestAlwaysAuthorization];
    if(view!=nil)
        [KVNProgress show];
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 500; // meters

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    
    [self.locationManager startUpdatingLocation];
    
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
   if(fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        [_locationManager stopUpdatingLocation];
        NSMutableDictionary *userInfo =[[NSMutableDictionary alloc] init];
        [userInfo setObject:location forKey:@"locationUser"];
       
       Perfil * p =[[BDServices sharedInstance]obtenerPerfil];
       if(p!=nil){
           p.longitud =  [NSNumber numberWithDouble:location.coordinate.longitude];
           p.latitud =  [NSNumber numberWithDouble:location.coordinate.latitude];
           [[BDServices sharedInstance]editPerfil:p];
       }
       
       [[Util sharedInstance]localiza:@[[[NSNumber alloc]initWithDouble:location.coordinate.longitude],[[NSNumber alloc]initWithDouble:location.coordinate.latitude]]];

       [KVNProgress dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:self userInfo:userInfo];
    }
}

-(void)getUserLoc:(UIView *)view{
    
    [self startStandardUpdates:view];
}



-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to{
    
        [KVNProgress dismiss];
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    return [distance floatValue];
}



-(void)showHudMessage:(NSString *)message :(UIView *)view{
    if(view!=nil)
        [KVNProgress show];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


-(NSString *)encodeImage:(UIImage *)image{

   // return    [Soap getBase64String:UIImageJPEGRepresentation(image, 1.0)];
 return [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:kNilOptions];

}


-(UIImage *)decodeImage:(NSString *)image64{

    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:image64 options:0];
    //Now data is decoded. You can convert them to UIImage
    UIImage *image = [UIImage imageWithData:decodedData];
    return image;
}

-(void)saveImageInGallery:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
}



- (void)saveImgePerfil:(NSString *)nombre image:(UIImage *)original scale:(CGFloat)scale
{
    
    
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(compressedImage, 1.0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",nombre]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
}


-(UIImage *)loadImagePerfil:(NSString *)nombre{
    UIImage *image = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",nombre]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])	{
        //if exists return image
        image = [UIImage imageWithContentsOfFile:imagePath];
        return image;
    }else{
        return nil;

    }

}



- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.jpg", fileName]];
    
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error]) {
        NSLog(@"Delete failed:%@", error);
    } else {
        NSLog(@"image removed: %@", fullPath);
    }
   }

-(void)saveFotosSubidas:(NSDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"DicKey"];
}


-(void)saveFotosBajadas:(NSArray *)fotos{
    [[NSUserDefaults standardUserDefaults] setObject:fotos forKey:@"fotosBajadas"];
}


-(NSArray *)getFotosBajadas{
    return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"fotosBajadas"]];
}

-(void)saveFotosEliminadas:(NSArray *)fotos{
    [[NSUserDefaults standardUserDefaults] setObject:fotos forKey:@"fotosEliminadas"];
}


-(NSArray *)getFotosEliminadas{
    return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"fotosEliminadas"]];
}


-(NSDictionary *)getFotosSubidas{
    return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicKey"] mutableCopy];
}


-(void)isGeolo:(bool)isgeolo{
    [[NSUserDefaults standardUserDefaults] setBool:isgeolo  forKey:@"geoloActive"];
}

-(bool)isGeolo{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"geoloActive"];
}

-(void)distanciaMax:(float)distancia{
    
    [[NSUserDefaults standardUserDefaults] setFloat:distancia forKey:@"distanciaMax"];
    
}

-(float)getDistanciaMax{
    return  [[NSUserDefaults standardUserDefaults] floatForKey:@"distanciaMax"];
}


-(void)rangoMax:(float)rmax{
    [[NSUserDefaults standardUserDefaults] setFloat:rmax forKey:@"rangoMax"];
}


-(float)rangoMax{
    return  [[NSUserDefaults standardUserDefaults] floatForKey:@"rangoMax"];
}

-(void)rangoMin:(float)rmin{
    [[NSUserDefaults standardUserDefaults] setFloat:rmin forKey:@"rangoMin"];
}

-(float)rangoMin{
    return  [[NSUserDefaults standardUserDefaults] floatForKey:@"rangoMin"];
}

-(void)guarda:(NSString *)clave :(NSString *)valor{
    [[NSUserDefaults standardUserDefaults] setObject:valor forKey:clave];
}

-(id)carga:(NSString *)clave{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:clave];
}

-(void)provinciaBusco:(float)idProv{
    [[NSUserDefaults standardUserDefaults] setFloat:idProv forKey:@"provinciaBuscar"];
}

-(float)provincia{
    float val = [[NSUserDefaults standardUserDefaults] floatForKey:@"provinciaBuscar"];
    if(val>0)
        return val;
    else
        return 0;
}

-(void)localiza:(NSArray *)valores{
    [[NSUserDefaults standardUserDefaults] setObject:valores forKey:@"localiza"];
}

-(NSArray *)localiza{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"localiza"];
}

-(void)loginByFB:(bool )valor{
    [[NSUserDefaults standardUserDefaults] setBool:valor forKey:@"loginByFB"];
}

-(bool)loginByFB{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"loginByFB"];
}

-(void)saveNombreFotoPrincipal:(NSString *)fotoP{
    
    [[NSUserDefaults standardUserDefaults] setObject:fotoP forKey:@"fotoPrincipal"];
}

-(NSString *)getFotoPpal{
    NSString *nombre =[[NSUserDefaults standardUserDefaults] objectForKey:@"fotoPrincipal"];
    return (nombre==nil) ? @"ninguna": nombre;
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if ( status == kCLAuthorizationStatusDenied ) {
        NSString *title;
        title =  NSLocalizedString(@"notificacion_alert_off",nil);
        NSString *message = NSLocalizedString(@"notification_alert_mess", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:NSLocalizedString(@"notificacion_button", nil), nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

-(UILabel *)editarTitulo:(NSString *)texto nombre:(NSString *)textoNombre label:(UILabel *)label{
    label.textColor =    [Util colorFromHexString:@"257d34"];
    NSDictionary *attribs = @{  NSFontAttributeName: label.font};
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:texto
                                           attributes:attribs];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:label.font.pointSize];
    NSRange nombreRange = [texto rangeOfString:textoNombre];
    
    [attributedText setAttributes:@{NSFontAttributeName:boldFont}
                            range:nombreRange];
    
    label.attributedText = attributedText;
    return label;
}
@end
