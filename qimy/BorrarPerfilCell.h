//
//  BorrarPerfilCell.h
//  qimy
//
//  Created by Agustín Embuena Majúa on 18/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrarPerfilCell : UITableViewCell <UIAlertViewDelegate>

- (IBAction)borrarAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sobreNosotros;
- (IBAction)buttonSobreNosotros:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonBorrar;
@end
