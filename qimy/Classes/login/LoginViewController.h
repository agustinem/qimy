//
//  LoginViewController.h
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
@interface LoginViewController : UIViewController <FBSDKLoginButtonDelegate, FBSDKSharingDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *claveTF;
@property (weak, nonatomic) IBOutlet UIButton *enterB;
@property (weak, nonatomic) IBOutlet UILabel *textAlertL;
@property (weak, nonatomic) IBOutlet UIButton *forgetB;
@property (weak, nonatomic) IBOutlet UIButton *registerB;
@property (weak, nonatomic) IBOutlet UITextField *confirmarTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelarB;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLogin;

- (IBAction)enterA:(id)sender;
- (IBAction)forgetA:(id)sender;
- (IBAction)registerA:(id)sender;

- (IBAction)sharedFacebook:(id)sender;
- (IBAction)aboutAs:(id)sender;


@end
