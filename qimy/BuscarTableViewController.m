//
//  BuscarTableViewController.m
//  qimy
//
//  Created by Agustín Embuena on 17/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>
#import "ResultadoViewController.h"
#import "BuscarTableViewController.h"
#import "BDServices.h"
#import "GeolocalizacionCell.h"
#import "ProvinciaTableViewCell.h"
#import "TituloCell.h"
#import "RangoCell.h"
#import "Util.h"
#import "Usuario.h"
#import "WSService.h"
#import "BorrarPerfilCell.h"
#import "Constants.h"
#import <iAd/iAd.h>
@interface BuscarTableViewController ()
    @property float heightAdView;
    @property bool ocultarProvincia;
    @property int alturaAd;
@property  UIView *viewContentIAD;
@end

@implementation BuscarTableViewController

-(void)geolocActivate:(NSNotification *)notifica{
    if([[notifica.userInfo objectForKey:@"activado"] isEqualToString:@"yes"])
        _ocultarProvincia = true;
    else
        _ocultarProvincia = false;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geolocActivate:) name:@"activaGeolo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(busquedaFinalizada:) name:kNotificationMuestraBusqueda object:nil];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]];
    if([[Util sharedInstance] isGeolo])
        _ocultarProvincia = true;

}

-(void)viewWillAppear:(BOOL)animated{

}

- (IBAction)back:(id)sender {
    [Util closeSession];
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

-(void)buscar:(id)sender{
    [[WSService sharedInstance] buscar:[[BDServices sharedInstance]obtenerPerfil]];
}

-(void)busquedaFinalizada:(NSNotification *)not{
    NSDictionary *dic = not.userInfo;
    if ([[dic objectForKey:@"resultado"] isEqualToString:@"OK"]) {
        [self performSegueWithIdentifier:@"resultadoSegue" sender:nil];
        //TODO BUSQUEDA
    }
}


-(void)viewDidDisappear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            GeolocalizacionCell *cellGeolo = [tableView dequeueReusableCellWithIdentifier:@"geoloCell" forIndexPath:indexPath];
            cellGeolo.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellGeolo;
            break;
        }
        case 1:{
            ProvinciaTableViewCell *cellProvincia = [tableView dequeueReusableCellWithIdentifier:@"provinciaCell" forIndexPath:indexPath];
            cellProvincia.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellProvincia;
            break;
        }
        case 2:{
            TituloCell *cellTitulo= [tableView dequeueReusableCellWithIdentifier:@"tituloCell" forIndexPath:indexPath];
            cellTitulo.tituloLabel.text= NSLocalizedString(@"buscar_distancia", nil);
            cellTitulo.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTitulo;
            break;
        }
        case 3:{
            RangoCell *cellRango= [tableView dequeueReusableCellWithIdentifier:@"rangoCell" forIndexPath:indexPath];
            cellRango.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellRango;
            break;
        }
        case 4:{
            TituloCell *cellTitulo1= [tableView dequeueReusableCellWithIdentifier:@"tituloCell1" forIndexPath:indexPath];
            cellTitulo1.tituloLabel.text = NSLocalizedString(@"buscar_edad", nil);
            cellTitulo1.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellTitulo1;
            break;
        }
        case 5:{
            RangoCell *cellRango1= [tableView dequeueReusableCellWithIdentifier:@"rangoCell1" forIndexPath:indexPath];
            cellRango1.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellRango1;
            break;
        }
        case 6:{
            BorrarPerfilCell *cellRango1= [tableView dequeueReusableCellWithIdentifier:@"botonBuscar" forIndexPath:indexPath];
            cellRango1.selectionStyle = UITableViewCellSelectionStyleNone;
            return cellRango1;
            break;
        }

        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            return cell;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==1 && _ocultarProvincia )return 0;
    if(indexPath.row ==1)return 164;
    if(indexPath.row ==2)return 70;
    if(indexPath.row ==3)return 70;
    if(indexPath.row ==4)return 70;
    if(indexPath.row ==5)return 70;
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _viewContentIAD = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,_heightAdView)];
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _heightAdView, self.view.frame.size.width, 50)];
    [_viewContentIAD addSubview:_adBanner];
    _adBanner.backgroundColor = [UIColor blackColor];
    _adBanner.delegate= self;
    return _viewContentIAD;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float tablaH = self.tableView.frame.size.height ;
    _heightAdView = tablaH - (70*4 +60 + 164);
    if(_ocultarProvincia)
        _heightAdView = _heightAdView-164;
    if(_heightAdView==50)
        _viewContentIAD.backgroundColor = [UIColor blackColor];
    return  _heightAdView;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultadoViewController *resultado = (ResultadoViewController *)[segue destinationViewController];
    resultado.resultados = [[BDServices sharedInstance]obtenerUsuarios];
    resultado.isFichaChat = false;
    [KVNProgress dismiss];
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


@end
