//
//  EncuentroCell.m
//  qimy
//
//  Created by Agustín Embuena on 29/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "EncuentroCell.h"
#import "Constants.h"
#import "ResultadoViewController.h"
@implementation EncuentroCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)imageAction:(id)sender {
    
    NSDictionary *fichaChat = @{@"idFicha":[[NSNumber alloc] initWithInteger:_userID]};
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationFichaChat object:nil userInfo:fichaChat];
}
@end
