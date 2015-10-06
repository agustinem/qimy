//
//  FotosTableViewCell.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "FotosTableViewCell.h"
#import "Constants.h"
#import "Util.h"
#import "BDServices.h"
#import "Perfil.h"
#import <KVNProgress/KVNProgress.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface FotosTableViewCell ()
@property UIAlertView *alertView;

@end

@implementation FotosTableViewCell

- (void)awakeFromNib {
    [self drawFotos];
}

-(void)drawFotos{
    _fotoPerfil=-1;
    _fotoLabel.text = NSLocalizedString(@"perfil_foto", nil);
    
    _images = @[_check1,_check2,_check3,_check4,_check5];
    _imagesView = @[_foto1,_foto2,_foto3,_foto4,_foto5];
    
    NSArray *fotosBajadas = [[Util sharedInstance ]getFotosBajadas];
    NSMutableArray *fotosFacebook = [NSMutableArray new];
    if([fotosBajadas count]<1 && _exitoFotosFacebook!=10){
        _exitoFotosFacebook=10;
        if ([FBSDKAccessToken currentAccessToken]) {
            [KVNProgress showWithStatus:NSLocalizedString(@"perfil_fotosFacebook_title", nil)];
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:[NSString stringWithFormat:@"me/albums"]
                                          parameters:nil
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                [KVNProgress dismiss];
                if (!error) {
                    NSArray *arrayResult = [result objectForKey:@"data"];
                    [arrayResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        NSDictionary *dic = obj;
                        if([[dic objectForKey:@"name"] isEqualToString:@"Profile Pictures"]){
                            *stop= YES;
                            NSString *idAlbum=[dic objectForKey:@"id"];
                            NSString * path = [NSString stringWithFormat:@"%@/photos/?fields=images&limit=5",idAlbum];
                            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                          initWithGraphPath:path
                                                          parameters:nil
                                                          HTTPMethod:@"GET"];
                            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                  id result,
                                                                  NSError *error) {
                                NSArray *arrayFotos = [result objectForKey:@"data"];
                                NSMutableDictionary * fotosSubidas = [[NSMutableDictionary alloc]initWithDictionary:[[Util sharedInstance]getFotosSubidas]];
                                [arrayFotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    NSDictionary *dicFoto = obj;
                                    NSURL *url = [NSURL URLWithString:[[[dicFoto objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source" ]];
                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                                    [fotosFacebook addObject:image];
                                    NSString *nombreFoto =[NSString stringWithFormat:@"imageLocal%lu",(unsigned long)idx];
                                    [[Util sharedInstance] saveImgePerfil:nombreFoto image:image scale:1.0];
                                    NSString *nombreFotoKey = [[NSString stringWithFormat:@"%lu",(unsigned long)idx] stringByAppendingString:nombreFoto];
                                    [fotosSubidas setObject:nombreFoto forKey:nombreFotoKey];
                                    [[Util sharedInstance]saveFotosSubidas:fotosSubidas];
                                    
                                }];
                                
                                ///asigno las fotos encontradas
                                [_imagesView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    UIImageView *itemImageView = obj;
                                    itemImageView.layer.borderWidth = 1.0f;
                                    itemImageView.layer.borderColor = [UIColor whiteColor].CGColor;
                                    //por defecto será no-img
                                    NSString *nombre = @"no-img";
                                    nombre = [NSString stringWithFormat:@"imageLocal%lu",(unsigned long)idx];
                                    UIImage *img=[[Util sharedInstance]loadImagePerfil:nombre];
                                    if(img==nil)
                                        img = [UIImage imageNamed:@"no-img"];
                                    itemImageView.image =img;
                                    
                                }];
                             
                            }];
                            [KVNProgress dismiss];
                        }
                    }];
                    NSLog(@"%@",result);
                   

                }
            }];
        }
    }else{
        
        //inicializo los check
        [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *check = obj;
            check.hidden = YES;
        }];
        
        //RECORRO CADA FOTO
        [_imagesView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            
            UIImageView *itemImageView = obj;
            itemImageView.layer.borderWidth = 1.0f;
            itemImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            //por defecto será no-img
            NSString *nombre = @"no-img";
            //si está en el array de bajada se pone
            NSMutableArray* fotosEliminadas = [[NSMutableArray alloc]initWithArray:[[Util sharedInstance]getFotosEliminadas]];
            if ((int) ([fotosBajadas count] -1) >= (int)idx ){
                if(![fotosEliminadas containsObject:[fotosBajadas objectAtIndex:idx]]){
                    
                    nombre = [fotosBajadas objectAtIndex:idx];
                    UIImageView *check= [_images objectAtIndex:idx];
                    if ([nombre containsString:@"principal_"]) {
                        nombre = [nombre stringByReplacingOccurrencesOfString:@"principal_" withString:@""];
                        [[Util sharedInstance] saveNombreFotoPrincipal:nombre];
                        //activa el check
                        
                        Perfil *perfil = [[BDServices sharedInstance]obtenerPerfil];
                        perfil.fotoSeleccionada = [[NSNumber alloc] initWithUnsignedLong: idx+1];
                        _fotoPerfil = idx;
                        [[BDServices sharedInstance] editPerfil:perfil];
                        check.hidden = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeFoto object:nil userInfo:@{@"foto":nombre}];
                    }else{
                        check.hidden = YES;
                        
                    }
                }
            }else{//aqui si no está el de bajada ponemos el de locla
                nombre = [NSString stringWithFormat:@"imageLocal%lu",(unsigned long)idx];
            }
            UIImage *img=[[Util sharedInstance]loadImagePerfil:nombre];
            if(img==nil)
                img = [UIImage imageNamed:@"no-img"];
            itemImageView.image =img;
            
            
        }];
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)newPhoto:(id)sender{
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.maximumNumberOfSelectionPhoto =1;
    picker.maximumNumberOfSelectionVideo = 0;
    [self.delegate loadPhoto:picker];
}


- (IBAction)selectPhotoPerfil:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger indexPhotoSelected = button.tag -1;
    _fotoPulsada = button.tag;
    NSString *photoName=[NSString stringWithFormat:@"imageLocal%lu",(unsigned long)indexPhotoSelected];
    NSArray *fotosBajadas = [[Util sharedInstance ]getFotosBajadas];
    NSArray *eliminadas =[[Util sharedInstance]getFotosEliminadas];
    if ((int) ([fotosBajadas count] ) > (int)indexPhotoSelected && (![eliminadas containsObject:[fotosBajadas objectAtIndex:indexPhotoSelected]])) {
        
        if(![eliminadas containsObject:[fotosBajadas objectAtIndex:indexPhotoSelected]])
        {
            photoName = [fotosBajadas objectAtIndex:indexPhotoSelected];
            if ([photoName containsString:@"principal_"]) {
                [[Util sharedInstance] saveNombreFotoPrincipal:photoName];
                photoName = [photoName stringByReplacingOccurrencesOfString:@"principal_" withString:@""];
            }
        }
    }
    if([[Util sharedInstance]loadImagePerfil:photoName] != nil){
        _alertView = [[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"perfil_alert_foto_title", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"perfil_alert_foto_cancelar", nil)  otherButtonTitles:NSLocalizedString(@"perfil_alert_foto_opcion3", nil),NSLocalizedString(@"perfil_alert_foto_opcion1", nil),NSLocalizedString(@"perfil_alert_foto_opcion2", nil), nil];
        _alertView.delegate = self;
        [_alertView show];
        
    }else{
        [self newPhoto:nil];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self seleccionar];
        _fotoPerfil = _fotoPulsada-1;
        NSString *nombre =nil;
        NSArray *fotosBajadas = [[Util sharedInstance ]getFotosBajadas];
        NSMutableArray* fotosEliminadas = [[NSMutableArray alloc]initWithArray:[[Util sharedInstance]getFotosEliminadas]];
        if ((int) ([fotosBajadas count] -1) >= _fotoPerfil && (![fotosEliminadas containsObject:[fotosBajadas objectAtIndex:_fotoPerfil]])){
            nombre = [fotosBajadas objectAtIndex:(unsigned long)_fotoPerfil];
            if ([nombre containsString:@"principal_"]) {
                nombre = [nombre stringByReplacingOccurrencesOfString:@"principal_" withString:@""];
                [[Util sharedInstance] saveNombreFotoPrincipal:nombre];
            }
            
        }else
            nombre = [NSString stringWithFormat:@"imageLocal%lu",(unsigned long)_fotoPerfil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeFoto object:nil userInfo:@{@"foto":nombre}];
        
    }else if(buttonIndex == 2){
        [self newPhoto:nil];
    }else if(buttonIndex == 3){
        [self eliminar];
    }
}

-(void)seleccionar{
    
    for(int i= 0; i<5;i++){
        UIImageView *check = [_images objectAtIndex:i];
        if(_fotoPulsada-1 == i){
            check.hidden =  NO;
            
            Perfil *p= [[BDServices sharedInstance] obtenerPerfil];
            p.fotoSeleccionada = [[NSNumber alloc] initWithInteger: _fotoPulsada];
            [[BDServices sharedInstance]editPerfil:p];
        }else
            check.hidden =  YES;
    }
}

-(void)eliminar{
    int indexPhoto =(int)_fotoPulsada-1;
    if(_fotoPerfil!=indexPhoto){
        UIImageView *imageView = [_imagesView objectAtIndex:indexPhoto];
        imageView.image = [UIImage imageNamed:@"no-img"];
        NSString *nombre =@"";
        NSMutableArray *fotosBajadas = [[NSMutableArray alloc] initWithArray:[[Util sharedInstance ]getFotosBajadas]];
        NSMutableDictionary *fotosSubidas = [[NSMutableDictionary alloc]initWithDictionary:[[Util sharedInstance]getFotosSubidas]];
        NSMutableArray* fotosEliminadas = [[NSMutableArray alloc]initWithArray:[[Util sharedInstance]getFotosEliminadas]];
        
        if ((int) ([fotosBajadas count] -1) >= indexPhoto && (![fotosEliminadas containsObject:[fotosBajadas objectAtIndex:indexPhoto]])){
            [fotosEliminadas addObject:[fotosBajadas objectAtIndex:indexPhoto]];
            [[Util sharedInstance]saveFotosEliminadas:fotosEliminadas ];
            
        }else{
            nombre = [NSString stringWithFormat:@"imageLocal%d",indexPhoto];
            NSString * nombreKey = [[NSString stringWithFormat:@"%d",indexPhoto] stringByAppendingString:nombre];
            [fotosSubidas removeObjectForKey:nombreKey];
            [[Util sharedInstance]saveFotosSubidas:fotosSubidas];
        }
        [[Util sharedInstance] removeImage:nombre];
    }else{
        [[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"perfil_alert_foto_error", nil) message:NSLocalizedString(@"perfil_alert_foto_error_mess", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"perfil_alert_foto_cancelar", nil) otherButtonTitles:nil, nil] show];
    }
}


@end
