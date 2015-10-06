//
//  PerfilTableViewController.m
//  qimy
//
//  Created by Agustín Embuena on 16/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "PerfilTableViewController.h"
#import "MenuTabBarController.h"
#import "PerfilTableViewCell.h"
#import "SexoTableViewCell.h"
#import "Util.h"
#import "Constants.h"
#import "ProvinciaTableViewCell.h"
#import "FotosTableViewCell.h"
#import "UzysAssetsPickerController.h"
#import "BDServices.h"
#import "WSService.h"
#import "BorrarPerfilCell.h"
#import "Perfil.h"

#import <KVNProgress/KVNProgress.h>

@interface PerfilTableViewController ()
    @property FotosTableViewCell *cellFotos ;
    @property float heightAdView;
    @property  NSMutableDictionary *fotosSubidas ;
    @property  NSMutableArray *fotosBajadas ;
    @property  NSMutableArray *fotosEliminadas;
    @property  int sumHeightCells;
    @property  UIView * viewContentIAD ;
@end

@implementation PerfilTableViewController


- (void)viewDidLoad {

    _sumHeightCells = 200+100+55+144+50+50;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrar" object:nil];
     self.clearsSelectionOnViewWillAppear = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(okPerfil:) name:kNotificationPerfilOK object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTabla:) name:@"actualizaTabla" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(borrarPerfil:) name:kNotificationBorrarPerfil object:nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]];

}

-(void)borrarPerfil:(NSNotification *)not{
    [KVNProgress dismiss];
    if([[not.userInfo objectForKey:@"resultado"] isEqualToString:@"OK"]){
        [Util closeSession];
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"perfil_error_eliminar_title", nil) message:NSLocalizedString(@"perfil_error_eliminar_title_msg", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

-(void)updateTabla:(NSNotification *)not{
        [KVNProgress dismiss];
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

-(void)okPerfil:(NSNotification *)not{
    MenuTabBarController *tab = (MenuTabBarController *)self.tabBarController;
    tab.index = 2;
    tab.selectedIndex =2;
    [tab barBuscar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row ==0)return 200;
    if(indexPath.row ==1)return 100;
    if(indexPath.row ==2)return 55;
    if(indexPath.row ==3)return 144;
    if(indexPath.row ==4)return 50;
    if(indexPath.row ==5)return 50;
    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    _viewContentIAD = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,_heightAdView)];
   _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _heightAdView, self.view.frame.size.width, 50)];
    [_viewContentIAD addSubview:_adBanner];
    _adBanner.delegate = self;
    if(_heightAdView==50)
        _viewContentIAD.backgroundColor = [UIColor blackColor];
    return _viewContentIAD;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float tablaH = self.tableView.frame.size.height ;
//    float screenH =[[UIScreen mainScreen]bounds].size.height;
    _heightAdView = tablaH  - _sumHeightCells ;
    if(_heightAdView<=50){
        _heightAdView =50;
        
    }
    return  _heightAdView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 6;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            PerfilTableViewCell *cellDatos = [tableView dequeueReusableCellWithIdentifier:@"datos" forIndexPath:indexPath];
            cellDatos.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellDatos;
            break;
        }
        case 1:{
            SexoTableViewCell *cellSexo = [tableView dequeueReusableCellWithIdentifier:@"sexo" forIndexPath:indexPath];
            cellSexo.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellSexo;
            break;
        }
        case 2:{
            ProvinciaTableViewCell *cellProvincia= [tableView dequeueReusableCellWithIdentifier:@"provincia" forIndexPath:indexPath];
            cellProvincia.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellProvincia;
            break;
        }
        case 3:{
            _cellFotos = [tableView dequeueReusableCellWithIdentifier:@"fotos" forIndexPath:indexPath];
            _cellFotos.selectionStyle = UITableViewCellSelectionStyleNone;
            _cellFotos.delegate = self;
            [_cellFotos drawFotos];
            return _cellFotos;
            break;
        }  case 4:{
            BorrarPerfilCell *borrarCell = [tableView dequeueReusableCellWithIdentifier:@"borrarPerfil" forIndexPath:indexPath];
            borrarCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return borrarCell;
            break;
        } case 5:{
            BorrarPerfilCell *sobreNosotrosCell = [tableView dequeueReusableCellWithIdentifier:@"sobreNosotrosPerfil" forIndexPath:indexPath];
            sobreNosotrosCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return sobreNosotrosCell;
            break;
        }
         
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            return cell;
            break;
        }
    }
}

#pragma mark - Delegate Cells

-(void)loadPhoto:(UzysAssetsPickerController *)controller
{
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //LAS FOTOS BAJADSA SE PUEDEN MODIFICAR POR MULTIPLE SELECCIÓN SI SE SUSTITUYEN HAY QUE QUITARLAS DE EN MEDIO
        _fotosBajadas = [[NSMutableArray alloc]initWithArray:[[Util sharedInstance] getFotosBajadas]];
        _fotosEliminadas = [[NSMutableArray alloc]initWithArray:[[Util sharedInstance]getFotosEliminadas]];
        _fotosSubidas = [[NSMutableDictionary alloc]initWithDictionary:[[Util sharedInstance]getFotosSubidas]];
        ALAsset *representation = obj;
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        
        UIImageView *iv = [_cellFotos.imagesView objectAtIndex:_cellFotos.fotoPulsada-1+idx];
        iv.image = img;
        int index =(int)(_cellFotos.fotoPulsada-1+idx);
        NSString *nombre = [NSString stringWithFormat:@"imageLocal%d",index];
        if(img.size.width>500)
            [[Util sharedInstance] saveImgePerfil:nombre image:img scale:500/img.size.width];
        else
            [[Util sharedInstance] saveImgePerfil:nombre image:img scale:1];
       NSString * nombreKey = [[NSString stringWithFormat:@"%lu",(unsigned long)index] stringByAppendingString:nombre];
        [_fotosSubidas setObject:nombre forKey:nombreKey];        
        //fotos bajadas existe y además estamos en rango
        if ((int) ([_fotosBajadas count] ) > index && (![_fotosEliminadas containsObject:[_fotosBajadas objectAtIndex:index]])){
                [_fotosEliminadas addObject:[_fotosBajadas objectAtIndex:index]];
                [[Util sharedInstance]saveFotosEliminadas:_fotosEliminadas];
        }

        [[Util sharedInstance]saveFotosSubidas:_fotosSubidas];
        if(_cellFotos.fotoPerfil == index){
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeFoto object:nil userInfo:@{@"foto":nombre}];
        }
    }];



    
}

-(void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker{

}

-(void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker{

}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
        if (_adBanner.superview == nil)
        {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{

    NSLog(@"Failed to retrieve ad");
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}



#pragma mark -Editando



@end
