//
//  LoginViewController.m
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "LoginViewController.h"
#import "WSService.h"
#import "BDServices.h"
#import "Constants.h"
#import "PerfilTableViewController.h"
#import "MenuTabBarController.h"
#import "Util.h"
#import "Perfil.h"
#import <KVNProgress/KVNProgress.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginButton.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface LoginViewController ()
@property bool isRegistrar;
@property NSMutableArray *localiza;
@end

@implementation LoginViewController

- (void)viewDidLoad {

    _confirmarTF.hidden = NO;
    _confirmarTF.alpha= 0;
    _localiza = [NSMutableArray new];
    _isRegistrar = false;
    self.facebookLogin.readPermissions = @[@"public_profile", @"email", @"user_photos"];
    self.facebookLogin.delegate= self;
    [super viewDidLoad];
    [self configureView];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barShow:) name:@"mostrar" object:nil];
    _versionLabel.text = [NSString stringWithFormat:@"V:%@",[Util getVersion]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barHide:) name:UIKeyboardWillShowNotification object:nil];
    // Do any additional setup after loading the view.
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewFetchedUserInfo:) name:FBSDKProfileDidChangeNotification object:nil];
}

-(void)updateVal:(NSNotification *)not{
    NSDictionary *di = [not userInfo];
    CLLocation *loc = [di objectForKey:@"locationUser"];
    [_localiza addObject:[[NSNumber alloc] initWithDouble:loc.coordinate.longitude]];
    [_localiza addObject:[[NSNumber alloc] initWithDouble:loc.coordinate.latitude]];
    [[Util sharedInstance]localiza:_localiza];

}
//
//-(void)barShow:(NSNotification *)not{
//    [self.navigationController.navigationBar setHidden:NO];
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//    if([Util firstLogin])
//        [self.navigationController.navigationBar setHidden:YES];
    [self.view endEditing:YES];
   [[Util sharedInstance] startStandardUpdates:nil];
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPAD){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _emailTF.text = [prefs objectForKey:@"usuarioLogin"];
    _claveTF.text = [prefs objectForKey:@"passwordLogin"];
    if([Util isUserLogin:_emailTF.text pass:_claveTF.text] ){
        [self enterA:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPAD){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [self keyboardWillHide:nil];
    }
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     MenuTabBarController *menu = [segue destinationViewController];
     if([segue.identifier isEqualToString:@"menuSegue"]){
         Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
         NSLog(@"%d", [perfil.fotoSeleccionada intValue]);
         if([perfil.edad integerValue] > 0 && [perfil.nombre length]>0 && [perfil.descripcion length]>0 && [perfil.fotoSeleccionada intValue] > 0){
             [Util perfilOK];
             menu.index = 2;
            }
     }
 }


#pragma mark -buttons
- (IBAction)enterA:(id)sender {
    double longitud = [[[[Util sharedInstance]localiza] objectAtIndex:0] doubleValue] ;
    double latit= [[[[Util sharedInstance]localiza] objectAtIndex:1] doubleValue] ;    
    if([self validar:true])
        [[WSService sharedInstance] login:_emailTF.text pass:_claveTF.text view:self.view :longitud   :latit];
}

- (IBAction)forgetA:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self performSegueWithIdentifier:@"forgetSegue" sender:nil];
    
}

- (IBAction)registerA:(id)sender {
    [[Util sharedInstance]loginByFB:false];
    UIButton *botonCancelar =(UIButton *)sender;
    if(_cancelarB.alpha == 1 && botonCancelar.tag != 10){
        if([self validar:false])
            [[WSService sharedInstance] registro:_emailTF.text pass:_claveTF.text view:self.view];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            if (!_isRegistrar) {
                _enterB.alpha = _isRegistrar;
                _facebookLogin.alpha = _isRegistrar;
                _textAlertL.alpha = _isRegistrar;
                _forgetB.alpha = _isRegistrar;
                [_registerB setTitle:  NSLocalizedString(@"login_button_register2", nil)
                        forState:UIControlStateNormal];
                _cancelarB.alpha = !_isRegistrar;
            }else{
                _confirmarTF.alpha= !_isRegistrar;
            }
        } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.15 animations:^{
            if(!_isRegistrar){
                _confirmarTF.alpha= !_isRegistrar;
            }else{
                _enterB.alpha = _isRegistrar;
                _facebookLogin.alpha = _isRegistrar;
                _textAlertL.alpha = _isRegistrar;
                _forgetB.alpha = _isRegistrar;
                _cancelarB.alpha = !_isRegistrar;
                
            }} completion:nil];
            _isRegistrar = !_isRegistrar;
        }];
        [_registerB setTitle:  NSLocalizedString(@"login_button_register2", nil)
                    forState:UIControlStateNormal];
        
    }
}

- (IBAction)sharedFacebook:(id)sender {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"%@",results);
}

/*!
 @abstract Sent to the delegate when the sharer encounters an error.
 @param sharer The FBSDKSharing that completed.
 @param error The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
        NSLog(@"%@",error);
}

/*!
 @abstract Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
        NSLog(@"%@",sharer);
}


- (IBAction)aboutAs:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLWEB ]];
}


#pragma mark - handlers

-(void)loginCompleted:(NSNotification *)notification{
    
    NSDictionary *val = [notification userInfo];
    NSString *res = [val objectForKey:@"resultado"];
    if([res isEqualToString:@"OK"]){
        [Util saveUserLoginUser:_emailTF.text pass:_claveTF.text];
        [KVNProgress showSuccess];
        [KVNProgress dismiss];
        [self performSegueWithIdentifier:@"menuSegue" sender:nil];
    }else{
         [KVNProgress dismiss];
        [Util showDefaultContentView: NSLocalizedString(@"ws_login_error", nil)];
    }
}


-(void)regCompleted:(NSNotification *)notification{
    NSDictionary *val = [notification userInfo];
    NSNumber *res = [val objectForKey:@"resultado"];
    int result = [res intValue];
    if(result == 1){
        [Util saveUserLoginUser:_emailTF.text pass:_claveTF.text];
        if([[Util sharedInstance]loginByFB])
        {
            [self enterA:nil];
        }
        else
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"registro_title_ok", nil) message:NSLocalizedString(@"registro_msg",nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Mail", nil] show];
    }else if(result == -1){
//        [Util showDefaultContentView: NSLocalizedString(@"ws_registrar_error", nil)];
    }
    else{
  //      [Util showDefaultContentView: NSLocalizedString(@"ws_error", nil)];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex!= [alertView cancelButtonIndex]){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"message://"]];
    }
}

#pragma mark -configurar vista

-(void)configureView{
    //text
    self.navigationController.title= NSLocalizedString(@"login_title", nil);
    [_enterB setTitle: NSLocalizedString(@"login_button_enter", nil) forState:UIControlStateNormal];
    [_registerB setTitle: NSLocalizedString(@"login_button_register", nil) forState:UIControlStateNormal];
    [_forgetB setTitle: NSLocalizedString(@"login_button_forget", nil) forState:UIControlStateNormal];
    _emailTF.placeholder = NSLocalizedString(@"login_placeholder_email", nil);
    _claveTF.placeholder = NSLocalizedString(@"login_placeholder_clave", nil);
    _confirmarTF.placeholder = NSLocalizedString(@"login_placeholder_confirmarclave", nil);
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        _textAlertL.hidden = YES;
        _textAlertL.text =  NSLocalizedString(@"login_label_textAlert", nil);
    }
    [_cancelarB setTitle:NSLocalizedString(@"login_button_registercancelar", nil) forState:UIControlStateNormal];
    _cancelarB.alpha = 0;
    
    //notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCompleted:) name:kNotificationUserOK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRegistroOK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regCompleted:) name:kNotificationRegistroOK object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateVal:) name:@"updateLocation" object:nil];

    

}

#pragma mark -touchEvents
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:TRUE];
}

- (void)keyboardWillShow:(NSNotification *)notification
{

        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -35.0f;  //set the -35.0f to your required value
            self.view.frame = f;
        }];

}

-(void)keyboardWillHide:(NSNotification *)notification
{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect f = self.view.frame;
            f.origin.y += 105.0f;  //set the -35.0f to your required value
            self.view.frame = f;
        }];
}

-(bool)validar:(bool)isLogin{    
    bool result =false;
    NSString *emailFormat1 = @"[A-Z0-9a-z._]+@[A-Za-z0-9]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat1];
    if (![emailTest1 evaluateWithObject:_emailTF.text]){
        UIAlertView *alerta2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_1", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
        [alerta2 show];
    } else if([_claveTF.text length]<6 || [_emailTF.text length]<6){
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_reg", nil) message:NSLocalizedString(@"login_validar_2", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
        [alerta show];
    }else if(!isLogin && ![_claveTF.text isEqualToString:_confirmarTF.text]){
            UIAlertView *alerta3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_3", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
            [alerta3 show];
    }else{
            result= true;
    }
    return result;
    
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    if (error) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
        UIAlertView *alerta3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_facebook_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
        [alerta3 show];
        // Process error
    } else if (result.isCancelled) {
            [FBSDKAccessToken setCurrentAccessToken:nil];
        UIAlertView *alerta3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_3", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
        [alerta3 show];
        // Handle cancellations
    } else {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"email"]) {
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         [[Util sharedInstance]loginByFB:true];
                         _emailTF.text = [result objectForKey:@"email"];
                         _claveTF.text = [[result objectForKey:@"email"] stringByAppendingString:[result objectForKey:@"email"] ];
                         _confirmarTF.text=[[result objectForKey:@"email"] stringByAppendingString:[result objectForKey:@"email"] ];
                         [[WSService sharedInstance] registro:_emailTF.text pass:_claveTF.text view:self.view];

                         NSLog(@"fetched user:%@", result);
                     }else{
                         UIAlertView *alerta3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_3", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil];
                         [alerta3 show];
                     }
                 }];
            }
        }
    }

}



/*!
 @abstract Sent to the delegate when the button was used to logout.
 @param loginButton The button that was clicked.
 */
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
        NSLog(@"%@",loginButton);
}


//-(void)loginViewFetchedUserInfo:(NSNotification *)notifica{
//    NSDictionary *dic = notifica.userInfo;
//    FBSDKProfile *profile = [dic objectForKey:@"FBSDKProfileOld"];
//    _emailTF.text =  profile.
//    _claveTF.text = [[dic objectForKey:@"email"] stringByAppendingString:[dic objectForKey:@"email"]];
//    [[WSService sharedInstance] registro:_emailTF.text pass:_claveTF.text view:self.view];
//}
@end
