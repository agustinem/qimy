//
//  MenuTabBarController.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "MenuTabBarController.h"
#import "BuscarTableViewController.h"
#import "QimyTableViewController.h"
#import "PerfilTableViewController.h"
#import "WSService.h"
#import "BDServices.h"
#import "Constants.h"
#import "Util.h"
@interface MenuTabBarController ()
@property     UIBarButtonItem *backButton ;
@property     UIBarButtonItem *search ;
@property  UIBarButtonItem *saveButton ;

@end

@implementation MenuTabBarController

-(void)buscarNot:(NSNotification *)not{
    [self buscar:nil];
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cambiarChat:) name:kNotificationChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buscarNot:) name:@"buscarNot" object:nil];

    _backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"perfil_sesion", nil)
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(back:)];
    _search = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(buscar:)];
    _search.style = UIBarButtonItemStylePlain;
    
    _saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"perfil_editar", nil)
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(save:)];
    
    self.delegate = self;
    [super viewDidLoad];
    self.selectedIndex = _index;
    if(_index ==0)
       [self barPerfil];
    if(_index ==2)
       [self barBuscar];
    
    
    UITabBar *tabBar = self.tabBar;
    
    
    [self editTabBar:tabBar
                    :0
                    :NSLocalizedString(@"tabbar_menu_1", nil)
                    :@"tab1_active"
                    :@"tab1" ];
    [self editTabBar:tabBar
                    :1
                    :NSLocalizedString(@"tabbar_menu_2", nil)
                    :@"tab2_active"
                    :@"tab2" ];
    
    [self editTabBar:tabBar
                    :2
                    :NSLocalizedString(@"tabbar_menu_3", nil)
                    :@"tab3_active"
                    :@"tab3" ];
    
    // Do any additional setup after loading the view.
}

-(void)cambiarChat:(NSNotification *)not{
    _index=1;
}


-(void)viewWillAppear:(BOOL)animated{
     self.selectedIndex = _index;
    if(self.selectedIndex == 0){
        [self barPerfil];
    }if(self.selectedIndex == 1){
            [self barChat];
    }else if(self.selectedIndex ==2){
        [self barBuscar];
    }
    _index = (int)self.selectedIndex;
}
/**
 *  Edit tabbar
 *
 *  @param tabBar        tabbar
 *  @param index         element
 *  @param title         title tabbar
 *  @param imageSelected image when selected tab
 *  @param image         image unselected tab
 */
-(void)editTabBar:(UITabBar *)tabBar  :(int)index :(NSString *)title :(NSString *)imageSelected :(NSString *)image{
    UITabBarItem *result = [tabBar.items objectAtIndex:index];
    [result setTitle:title];
    [result setSelectedImage:[[UIImage imageNamed:imageSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [result setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    result.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.000], NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue" size:7.0f], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:1 blue:1 alpha:1.000], NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue" size:7.0f], NSFontAttributeName, nil] forState:UIControlStateDisabled];
    
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark - delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if([viewController isKindOfClass:([PerfilTableViewController class])]){
        PerfilTableViewController *pController = (PerfilTableViewController *)viewController;
        [pController.tableView reloadData];
        
    }  if([viewController isKindOfClass:([QimyTableViewController class])]){
        QimyTableViewController *qController = (QimyTableViewController *)viewController;
        [qController.tableView reloadData];
    }
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(![Util  isPerfilOK]){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_error_perfil", nil) message:NSLocalizedString(@"alert_error_perfil_mesg", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        self.selectedIndex = 0;
        return NO;
    }else if([viewController isKindOfClass:([BuscarTableViewController class])]){
            [self barBuscar];
                _index=2;
    }else if([viewController isKindOfClass:([QimyTableViewController class])]){
        [self barChat];
        _index=1;
    }else{
        [self barPerfil];
        _index=0;
    }
    return YES;
}


-(void)barBuscar{
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.rightBarButtonItem = _search;
    self.navigationItem.title = NSLocalizedString(@"buscar_title", nil);

}


-(void)barChat{
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = NSLocalizedString(@"chat_title", nil);
    
}


-(void)barPerfil{
    self.navigationItem.leftBarButtonItem = _backButton;
    self.navigationItem.rightBarButtonItem = _saveButton;
    self.navigationItem.title = NSLocalizedString(@"perfil_title", nil);
}


- (void)back:(id)sender {
    [Util closeSession];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buscar:(id)sender{
    if([Util isPerfilOK])
        [[WSService sharedInstance] buscar:[[BDServices sharedInstance]obtenerPerfil]];
    else
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_error_perfil", nil) message:NSLocalizedString(@"alert_error_perfil_mesg", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)save:(id)sender {
    Perfil *perfil = [[BDServices sharedInstance] obtenerPerfil];
    if([Util validar:perfil]){
        [Util perfilOK];
        double longitud = [[[[Util sharedInstance]localiza] objectAtIndex:0] doubleValue] ;
        double latit= [[[[Util sharedInstance]localiza] objectAtIndex:1] doubleValue] ;
        [[WSService sharedInstance]editUsuarionuevopassword:nil perfil:perfil latitud:latit longitud:longitud];
    }
    
}


@end
