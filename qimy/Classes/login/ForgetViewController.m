//
//  ForgetViewController.m
//  qimy
//
//  Created by Agustín Embuena on 4/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "ForgetViewController.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "WSService.h"
@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enviado:) name:kNotificationRecuperaClave object:nil];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [self keyboardWillHide:nil];
    [self configureView];
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPAD){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [self.mailTF becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPAD){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [self.mailTF resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)configureView{
    //text
  
    _textAlert.text = NSLocalizedString(@"forget_label_text", nil);
    [_sendB setTitle: NSLocalizedString(@"forget_button_enter", nil) forState:UIControlStateNormal];
    _mailTF.placeholder = NSLocalizedString(@"forget_placeholder_email", nil);
    
    //navigation,
    [self.navigationController.navigationBar setHidden:NO];
}


- (IBAction)sendActionB:(id)sender {
    if([self validarMail])
        [[WSService sharedInstance] pedirClave:_mailTF.text];
}

-(void)enviado:(NSNotification *)notifica{

    NSDictionary *dic= notifica.userInfo;
    if([[dic objectForKey:@"resultado"] isEqualToString:@"OK"]){
        [KVNProgress showSuccess];
        [KVNProgress dismiss];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"forget_alert_title", nil) message:NSLocalizedString(@"forget_alert_message",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        [KVNProgress dismiss];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"forget_alert_title_ko", nil) message:NSLocalizedString(@"forget_alert_message_ko",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
}

-(bool)validarMail{
    bool result =false;
    NSString *emailFormat1 = @"[A-Z0-9a-z._]+@[A-Za-z0-9]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat1];
    if (![emailTest1 evaluateWithObject:_mailTF.text]){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login_validar_er", nil) message:NSLocalizedString(@"login_validar_1", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"login_validar_ok", nil) otherButtonTitles:nil, nil] show];
    }else{
        result=true;
    }
    return result;
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

@end
