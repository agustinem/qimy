//
//  EncuentroCell.h
//  qimy
//
//  Created by Agustín Embuena on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncuentroCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *fotoPrincipal;

@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *mensaje;
@property NSString *nombreUser;
@property NSInteger userID;
@property NSInteger encuentroID;
- (IBAction)imageAction:(id)sender;
@end
