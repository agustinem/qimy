//
//  QimyPresentViewController.m
//  qimy
//
//  Created by Agustín Embuena on 28/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "QimyPresentViewController.h"
#import "Constants.h"
#import "MenuTabBarController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Util.h"
@interface QimyPresentViewController ()

@end

@implementation QimyPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _labelText1.text = NSLocalizedString(@"textoQimy1",nil);
    _labelText2.text = NSLocalizedString(@"textoQimy2",nil);
    _imageViewUser1.layer.cornerRadius =  90;
    _imageViewUser1.clipsToBounds = YES;
    _imageViewUser2.layer.cornerRadius =  90;
    _imageViewUser2.clipsToBounds = YES;

    // Do any additional setup after loading the view.
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
-(void)viewWillAppear:(BOOL)animated{
    if(_nombrePubli!=nil){
        _close.hidden = NO;
        _publicidadQimy.hidden= NO;
        _botonWeb.hidden = NO;
        [_publicidadQimy sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLBANNER,_nombrePubli]] placeholderImage:[UIImage imageNamed:@"pattern"]];
        _publicidadQimy.userInteractionEnabled = YES;
    }else{
        _close.hidden= YES;
        _publicidadQimy.hidden= YES;
        _botonWeb.hidden= YES;
    NSString *imageName =[[Util sharedInstance]getFotoPpal];
    [_imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,imageName]] placeholderImage:[UIImage imageNamed:@"no-img"]];
    [_imageViewUser2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,_fotoName]] placeholderImage:[UIImage imageNamed:@"no-img"]];
    }
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdelante object:nil];
    }];
}


- (IBAction)verChat:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cambiarChat" object:nil];
    }];

}

- (IBAction)goWeb:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlPubli ]];
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
