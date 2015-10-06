//
//  SexoTableViewCell.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexoTableViewCell : UITableViewCell

@property bool isMujer;
@property bool buscoHombre;
@property bool buscoMujer;
@property NSInteger desde;
@property NSInteger hasta;
@property (weak, nonatomic) IBOutlet UILabel *labelSexo;
@property (weak, nonatomic) IBOutlet UILabel *labelInteresa;
@property (weak, nonatomic) IBOutlet UIButton *selectedSex;
@property (weak, nonatomic) IBOutlet UIButton *selectedSex1;
@property (weak, nonatomic) IBOutlet UIButton *interesaMujer;
@property (weak, nonatomic) IBOutlet UIButton *interesaHombre;
- (IBAction)mujersexo:(id)sender;
- (IBAction)hombreSexo:(id)sender;
- (IBAction)interesaMujer:(id)sender;
- (IBAction)interesaHombre:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelTextoRango;

@end
