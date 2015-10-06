//
//  FotosTableViewCell.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//


@class UzysAssetsPickerController;
@protocol ChangePictureProtocolo
-(void)loadPhoto:(UzysAssetsPickerController *)controller;
@end


#import <UIKit/UIKit.h>
#import "PerfilTableViewController.h"
#import "UzysAssetsPickerController.h"



@interface FotosTableViewCell : UITableViewCell < UIAlertViewDelegate>

@property NSInteger fotoPulsada;
@property NSInteger fotoPerfil;
@property NSArray *imagesView;
@property NSArray *images;


@property (weak, nonatomic) IBOutlet UILabel *fotoLabel;
@property id<ChangePictureProtocolo> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *foto1;
@property (weak, nonatomic) IBOutlet UIImageView *foto2;
@property (weak, nonatomic) IBOutlet UIImageView *foto3;
@property (weak, nonatomic) IBOutlet UIImageView *foto4;
@property (weak, nonatomic) IBOutlet UIImageView *foto5;

@property (weak, nonatomic) IBOutlet UIImageView *check1;
@property (weak, nonatomic) IBOutlet UIImageView *check2;
@property (weak, nonatomic) IBOutlet UIImageView *check3;

@property (weak, nonatomic) IBOutlet UIImageView *check4;
@property (weak, nonatomic) IBOutlet UIImageView *check5;


@property int exitoFotosFacebook;
- (IBAction)selectPhotoPerfil:(id)sender;

-(void)drawFotos;
@end
