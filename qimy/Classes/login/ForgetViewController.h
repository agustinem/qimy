//
//  ForgetViewController.h
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *textAlert;
@property (weak, nonatomic) IBOutlet UITextField *mailTF;
@property (weak, nonatomic) IBOutlet UIButton *sendB;
- (IBAction)sendActionB:(id)sender;

@end
