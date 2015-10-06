//
//  PerfilTableViewCell.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilTableViewCell : UITableViewCell <UITextViewDelegate ,UITextFieldDelegate>

@property NSString *nombre;
@property NSInteger edadVal;
@property NSString *descripcionVal;

@property (weak, nonatomic) IBOutlet UIImageView *imagePerfil;
@property (weak, nonatomic) IBOutlet UITextField *nombreTF;
@property (weak, nonatomic) IBOutlet UITextField *edad;
@property (weak, nonatomic) IBOutlet UITextView *descripcion;


@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
