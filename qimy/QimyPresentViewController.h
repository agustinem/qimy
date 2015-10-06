//
//  QimyPresentViewController.h
//  qimy
//
//  Created by Agustín Embuena on 28/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QimyPresentViewController : UIViewController

- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *mask;
@property NSString *fotoName;
@property NSString *urlPubli;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser2;
@property (weak, nonatomic) IBOutlet UILabel *labelText1;
@property (weak, nonatomic) IBOutlet UILabel *labelText2;
@property (weak, nonatomic) IBOutlet UIImageView *publicidadQimy;
@property NSString *nombrePubli;
- (IBAction)verChat:(id)sender;
- (IBAction)goWeb:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *botonWeb;
@property (weak, nonatomic) IBOutlet UIButton *close;
- (IBAction)close:(id)sender;

@end
