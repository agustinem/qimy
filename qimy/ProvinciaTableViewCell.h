//
//  ProvinciaTableViewCell.h
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinciaTableViewCell : UITableViewCell <UIPickerViewDataSource,UIPickerViewDelegate>

@property NSString * provincia;
@property (weak, nonatomic) IBOutlet UILabel *labelProvincia;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *provinciaTF;

@end
