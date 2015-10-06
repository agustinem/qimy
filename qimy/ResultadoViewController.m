//
//  ResultadoViewController.m
//  qimy
//
//  Created by Agustín Embuena on 17/6/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//

#import "ResultadoViewController.h"
#import "BuscarTableViewController.h"
#import "MenuTabBarController.h"
#import "Usuario.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "BDServices.h"
#import "Provincia.h"
#import "FichaQimy.h"
#import "Perfil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Util.h"
#import "WSService.h"
#import "QimyPresentViewController.h"
#import "AppDelegate.h"
#import <stdlib.h>
#import "Publicidad.h"
@interface ResultadoViewController ()
@property CGRect contentRect;
@property   NSMutableArray *fichas;
@property   NSMutableArray *fotosFicha;
@property   NSMutableArray *fotosChicas;
@property   UIView * contenMenu;
@property   UILabel * labelDescripcion;
@property   UILabel * labelTitulo;
@property   float posInicial;
@property   FichaQimy * fichaActual;
@property   int fichaActualIndex;
@property   LGSublimationView *lgSublimer;
@property UIImageView *boton ;
@property UIImageView *imageNOQ;
@property bool isbackActive;
@property UIView * qimyBar;
@property     UIImageView * limitIZQ;
@property bool pulsaQimyOK ;
@property QimyPresentViewController * qimyVC;
@property int contadorQimy;

@end

@implementation ResultadoViewController


-(void)loadFichaActual:(NSInteger)pageActual{
    //inicializo todo para una nueva página
    _fichaActualIndex= (int) pageActual;
    //reincio fondo
    //FONDO
    [_lgSublimer removeFromSuperview];
    [self loadFondo];
    [self.view addSubview:_lgSublimer];
    [self.view sendSubviewToBack:_lgSublimer];
    
    //CARGANDO DATOS
    if (pageActual < [_resultados count] && pageActual>=0) {
        Usuario *user = [_resultados objectAtIndex:pageActual];
        Provincia *provincia = [[BDServices sharedInstance] obtenerProvincia:[user.idProvincia intValue]];
        //titulo
        NSString *tituloString = [NSString stringWithFormat:@"%@, %d, %@",user.nombre,[user.edad intValue],provincia.nombre];
        
        //fotos DE FONDO Y CHICAS
        _fotosFicha = [NSMutableArray new];
        _fotosChicas = [NSMutableArray new];
        NSArray *arrayFotos = [[user.fotos componentsSeparatedByString:@"***"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        float ancho = self.view.frame.size.width/5;
        
        [arrayFotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *imageViewChica = [[UIImageView alloc]initWithFrame:CGRectMake(ancho*idx+10, 95, ancho-20, ancho-20)];
            imageViewChica.contentMode = UIViewContentModeScaleAspectFill;
            imageViewChica.layer.cornerRadius = (ancho-20)/2;
            
            imageViewChica.clipsToBounds=YES;
            imageViewChica.userInteractionEnabled = YES;
            imageViewChica.tag = 30+idx;
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds=YES;
            imageView.userInteractionEnabled= YES;
            imageView.tag  = 40+idx;
            
            NSString *nombreFoto= obj;
            if([nombreFoto containsString:@"principal"])      {
                nombreFoto = [nombreFoto stringByReplacingOccurrencesOfString:@"principal_" withString:@""];
                if(_qimyVC==nil)
                    _qimyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"qimyOK"];
                _qimyVC.fotoName = nombreFoto;
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,nombreFoto]]
                             placeholderImage:[UIImage imageNamed:@"no-img"]];
                
                [_fotosFicha insertObject:imageView atIndex:0];
                [imageViewChica sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_chica.jpg",URLImages,nombreFoto]]
                                  placeholderImage:nil];
                [_fotosChicas insertObject:imageViewChica atIndex:0];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,nombreFoto]]
                             placeholderImage:[UIImage imageNamed:@"no-img"]];
                [_fotosFicha addObject:imageView];
                [imageViewChica sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_chica.jpg",URLImages,nombreFoto]]
                                  placeholderImage:nil];
                [_fotosChicas addObject:imageViewChica];
            }
            
        }];
        
        //CREO LA NUEVA FICHA CON LOS DATOS
        
        _fichaActual = [[FichaQimy alloc] initWithImagePrincipal:nil imagelist:user.fotos titulo:tituloString desc:user.descripcion nombre:user.nombre idUser:user.idPerfil];
        [_fichas addObject:_fichaActual];
        
        //incializo valores de nueva ficha
        _contenMenu.alpha =1;
        _imageNOQ.alpha = 0;
        
        //titulo
        _labelTitulo = [[Util sharedInstance] editarTitulo:_fichaActual.titulo nombre:_fichaActual.nombre label:_labelTitulo];
        
        //descripcion
        _labelDescripcion.text = _fichaActual.descripcion;
        
        //boton back
        if(_isbackActive){
            _limitIZQ.alpha=1;
            _isbackActive = false;
        }else{
            _limitIZQ.alpha=0;
        }
        
        //borrar si las hay
        for (UIView *i in _contenMenu.subviews){
            if([i isKindOfClass:[UIImageView class]]){
                UIImageView *newIV = (UIImageView *)i;
                if(newIV.tag >=3000){
                    [newIV removeFromSuperview];
                }
            }
        }
        //fotos pequeñas
        [_fotosChicas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = obj;
            imageView.tag = 3000+idx;
            float ancho = self.view.frame.size.width/5;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 40+idx;
            [button setBackgroundImage:imageView.image forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, ancho-20, ancho-20);
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(changePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [_contenMenu addSubview:imageView];
            [imageView addSubview:button];
        }];
        
        _lgSublimer.viewsToSublime= _fotosFicha;
        _pulsaQimyOK =true;
        _qimyVC.nombrePubli=nil;
        if(_contadorQimy >2){
            _contadorQimy = 0;
            [self muestraPubli];
        }
        //colocar el contenedror en su sitio
        int posyContent=self.view.frame.size.height-160;
        if (_isFichaChat) {
            posyContent = posyContent+50;
        }
        _contenMenu.frame = _contentRect;
        _boton.image=[UIImage imageNamed:@"profile-up"];
        _qimyBar.alpha = 1;
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noqimy", nil) message:NSLocalizedString(@"noqimy_msg", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(void)muestraPubli{
    NSArray * publis =[[BDServices sharedInstance]obtenerPubli];
    int r = rand() % ([publis count]-1);
    Publicidad *p =publis[r];
    _qimyVC.nombrePubli =p.ruta;
    _qimyVC.urlPubli = p.web;
    [self presentViewController:_qimyVC animated:YES completion:nil];
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor blackColor]];
    //FICHAS Q SE PINTAN
    _fichas = [NSMutableArray new];
    
    
    //boton de cerrar en caso de q vengamos del cht
    if(_isFichaChat){
        
        UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonClose.tag = 50;
        buttonClose.frame = CGRectMake(self.view.frame.size.width -35, 20,25, 25);
        [buttonClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [buttonClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonClose];
    }
    
    //imagen de se ha hecho qimy o no
    _imageNOQ = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-110, 200, 220)];
    [self.view addSubview:_imageNOQ];
    if(!_isFichaChat){
        [self loadBarQimy];
    }
    [self loadContenedor];
    
    [self loadFichaActual:_fichaActualIndex];
    
    //publicidad
    int posY =self.view.frame.size.height-60;
    if(_isFichaChat)
        posY=posY+60;
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, posY, self.view.frame.size.width, 50)];
    _adBanner.delegate = self;
    
    //construcción de la vista
    
    [self.view addSubview:_contenMenu];
    [self.view addSubview:_qimyBar];
    [self.view addSubview:_adBanner];
    
    //cargando los primeros datos
    [self loadFichaActual:0];
    
}

-(void)loadFondo{
    _lgSublimer = [[LGSublimationView alloc]initWithFrame:self.view.bounds];
    _lgSublimer.delegate = self;
    UIView* shadeView = [[UIView alloc]initWithFrame:_lgSublimer.frame];
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0;
    _lgSublimer.inbetweenView = shadeView;
    [UIView animateWithDuration:0.2
                     animations:^{
                         _lgSublimer.alpha =1;}];
}

-(void)loadBarQimy{
    _qimyBar = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.frame.size.height-220, self.view.frame.size.width, 70)];
    [self.view addSubview:_qimyBar];
    _qimyBar.alpha = 1;
    UIView * backgroundBar = [[UIView alloc ]initWithFrame:CGRectMake(0, 12, self.view.frame.size.width, 46)];
    backgroundBar.alpha = 0.5;
    backgroundBar.backgroundColor = [UIColor blackColor];
    [_qimyBar addSubview:backgroundBar];
    [_qimyBar sendSubviewToBack:backgroundBar];
    //boton limitizq
    _limitIZQ = [[UIImageView alloc]initWithFrame:CGRectMake(10, 21 , 15, 27)];
    _limitIZQ.image = [UIImage imageNamed:@"but-back"];
    _limitIZQ.userInteractionEnabled = YES;
    //boton
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setBackgroundColor:[UIColor clearColor]];
    buttonBack.tag = 52;
    buttonBack.frame = CGRectMake(0, 0, 30,30);
    [buttonBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_limitIZQ addSubview:buttonBack];
    
    _limitIZQ.alpha=0;
    //boton qimy o no qimy
    //imagen
    UIImageView *botonQOk =     [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 +30, 0, 70, 70)];
    botonQOk.image = [UIImage imageNamed:@"but-q"];
    botonQOk.userInteractionEnabled = YES;
    //boton
    UIButton *buttonOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonOk setBackgroundColor:[UIColor clearColor]];
    buttonOk.tag = 50;
    buttonOk.frame = CGRectMake(0, 0, 70,70);
    [buttonOk addTarget:self action:@selector(qimy:) forControlEvents:UIControlEventTouchUpInside];
    [_qimyBar addSubview:botonQOk];
    [botonQOk addSubview:buttonOk];
    //imagen
    UIImageView *botonQKO =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -90, 0, 70, 70)];
    
    botonQKO.image = [UIImage imageNamed:@"but-noq"];
    botonQKO.userInteractionEnabled = YES;
    //boton
    UIButton *buttonKO = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonKO setBackgroundColor:[UIColor clearColor]];
    buttonKO.tag = 51;
    buttonKO.frame = CGRectMake(0, 0, 70,70);
    [buttonKO addTarget:self action:@selector(qimy:) forControlEvents:UIControlEventTouchUpInside];
    [_qimyBar addSubview:botonQKO];
    [botonQKO addSubview:buttonKO];
    [_qimyBar addSubview:_limitIZQ];
}

-(void)loadContenedor{
    //contenedor
    int posyContent=self.view.frame.size.height-160;
    if (_isFichaChat) {
        posyContent = posyContent+50;
    }
    _contenMenu = [[UIView alloc ]initWithFrame:CGRectMake(0, posyContent, self.view.frame.size.width, 400)];
    [self.view addSubview:_contenMenu];
    _contentRect = _contenMenu.frame;
    
    //FONDO
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    background.image = [UIImage imageNamed:@"profile-backgr"];
    background.tag = 400;
    [_contenMenu addSubview:background];
    
    
    //label titulo
    _labelTitulo = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, self.view.frame.size.width-90, 30)];
    _labelTitulo.textColor = [Util colorFromHexString:@"257d34"];
    [_contenMenu addSubview:_labelTitulo];
    //label descripcion
    _labelDescripcion = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, self.view.frame.size.width-90, 60)];
    _labelDescripcion.numberOfLines = 3;
    _labelDescripcion.textColor = [UIColor grayColor];
    [_contenMenu addSubview:_labelDescripcion];
    //fotos
    //las fotos se crean segun los contenidos
    
    //botón denunciar y eliminar
    float posY = self.view.frame.size.width/5 + 95;
    UIButton *buttonEliminar = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonEliminar setTitle:NSLocalizedString(@"eliminarButton", nil) forState:UIControlStateNormal];
    [buttonEliminar addTarget:self action:@selector(eliminar:) forControlEvents:UIControlEventTouchUpInside];
    [buttonEliminar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonEliminar.frame = CGRectMake(self.view.frame.size.width/4 -50, posY, 100,50);
    [_contenMenu addSubview:buttonEliminar];
    
    UIButton *buttonDenunciar = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDenunciar setTitle:NSLocalizedString(@"denunciartButton", nil) forState:UIControlStateNormal];
    [buttonDenunciar addTarget:self action:@selector(denunciar:) forControlEvents:UIControlEventTouchUpInside];
    [buttonDenunciar setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonDenunciar.frame = CGRectMake(self.view.frame.size.width*3/4 - 50, posY, 100,50);
    [_contenMenu addSubview:buttonDenunciar];
    
    
    //BOTÓN desplazamineto
    
    _boton = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 10, 25, 25)];
    _boton.userInteractionEnabled= YES;
    _boton.image = [UIImage imageNamed:@"profile-up"];
    UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton setBackgroundColor:[UIColor clearColor]];
    boton.tag = 51;
    boton.frame = CGRectMake(0, 0, 25,25);
    [boton addTarget:self action:@selector(handleSwipe:) forControlEvents:UIControlEventTouchUpInside];
    [_boton addSubview:boton];
    [_contenMenu addSubview:_boton];
    
    
    //TOQUES
    _contenMenu.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [_contenMenu addGestureRecognizer:swipeUp];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [_contenMenu addGestureRecognizer:swipeDown];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1) {
        if(buttonIndex ==1)
            [self confirmaDenuncia];
    }else if (alertView.tag==2){
        if(buttonIndex ==1)
            [self confirmaElimina];
    }
}


-(void)denunciar:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"denunciartButton", nil) message:NSLocalizedString(@"notifica_denunciar", nil) delegate:self cancelButtonTitle:@"NO" otherButtonTitles:NSLocalizedString(@"denunciartButton", nil), nil];
    alert.tag = 1;
    alert.delegate= self;
    [alert show];
}

-(void)confirmaDenuncia{
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    [[WSService sharedInstance] editDenuncia:[p.idPerfil intValue]  envioAId:[_fichaActual.idUsuario intValue]];
}

-(void)eliminar:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"eliminarButton", nil) message:NSLocalizedString(@"notifica_eliminar", nil) delegate:self cancelButtonTitle:@"NO" otherButtonTitles:NSLocalizedString(@"eliminarButton", nil), nil];
    alert.tag = 2;
    alert.delegate= self;
    [alert show];
}

-(void)confirmaElimina{
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    [[WSService sharedInstance] editBloqueo:[p.idPerfil intValue]  envioAId:[_fichaActual.idUsuario intValue]];
}

-(void)back:(id)sender{
    _fichaActualIndex--;
    _contadorQimy--;
    _isbackActive=false;
    [self loadFichaActual:_fichaActualIndex];
    _imageNOQ.alpha = 1.0;
}

-(void)qimy:(id)sender{
    _isbackActive=true;
    UIButton *but = (UIButton *)sender;
    int val = 1;
    _pulsaQimyOK=true;
    if(but.tag!=50){
        val=0;
        _pulsaQimyOK=false;
    }
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    Usuario *user = [_resultados objectAtIndex:_fichaActualIndex];
    [[WSService sharedInstance] editEncuentro:[p.idPerfil intValue] envioAId:[user.idPerfil intValue] qimy:val];
}

-(void)adelante{
    _contadorQimy++;
    _fichaActualIndex++;
    [self loadFichaActual:_fichaActualIndex];
}

-(void)close:(NSNotification *)not{
    _qimyVC.nombrePubli= nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)changePhoto:(id)sender{
    _lgSublimer.botonPulsado = true;
    
    UIButton *button = (UIButton *)sender;
    int index = (int)button.tag-40;
    _lgSublimer.siguientePage = index+1;
    CGRect frame = _lgSublimer.scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    
    [_lgSublimer.scrollView scrollRectToVisible:frame animated:NO];
    
    //updates scroll data
    _lgSublimer.lastXOffset = _lgSublimer.scrollView.contentOffset.x;
    _lgSublimer.currentPage = _lgSublimer.siguientePage;
    _lgSublimer.pageControl.currentPage = _lgSublimer.currentPage-1;
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture    {
    CGRect frame = _contenMenu.frame;
    bool isVisible = false;
    UIImage *image=[UIImage imageNamed:@"profile-down"];
    if (frame.origin.y== _posInicial){
        frame.origin.y -= 180;
        
    }
    else if (frame.origin.y == _posInicial-180){
        frame.origin.y += 180;
        image =[UIImage imageNamed:@"profile-up"];
        isVisible= true;
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         _contenMenu.frame = frame;
                         _boton.image = image;
                         if(isVisible)
                             _qimyBar.alpha = 1;
                         //                             _qimyBar.frame = CGRectMake(0, _contenMenu.frame.origin.y-70, self.view.frame.size.width, 50);
                         else
                             _qimyBar.alpha = 0;
                     }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animacion:) name:kNotificationQimy object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bloqueo:) name:kNotificationBloqueo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(denuncia:) name:kNotificationDenuncia object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cambiarChat:) name:kNotificationChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adelantePersona:) name:kNotificationAdelante object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(muestraQimy:) name:kNotificationEncuentros object:nil];
    
}


-(void)adelantePersona:(NSNotification *)not{
    _imageNOQ.image= nil;
    [self adelante];
}

-(void)cambiarChat:(NSNotification *)not{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)lgSublimationView:(LGSublimationView*)view didEndScrollingOnPage:(NSUInteger)page{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    _contadorQimy = 0;
    [self.navigationController.navigationBar setHidden:_isFichaChat];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//


-(void)viewDidAppear:(BOOL)animated{
    _posInicial = _contenMenu.frame.origin.y;
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

-(void)bloqueo:(NSNotification *)not{
    NSDictionary *dic = not.userInfo;
    bool error = false;
    if ([[dic objectForKey:@"resultado"] isEqualToString:@"OK"]) {
        if([[dic objectForKey:@"bloqueo"] isEqualToString:@"OK"]){
            //    Usuario *user = [_resultados objectAtIndex:_fichaActualIndex];
            //            [[BDServices sharedInstance]eliminaUsuario:user];
            [self adelante];
        }else{
            error = true;
        }
    }else
        error= true;
    if(error){
        [[[UIAlertView alloc] initWithTitle:@"Upps" message:@"Error.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}


-(void)denuncia:(NSNotification *)not{
    NSDictionary *dic = not.userInfo;
    bool error = false;
    if ([[dic objectForKey:@"resultado"] isEqualToString:@"OK"]) {
        if([[dic objectForKey:@"denuncia"] isEqualToString:@"OK"]){
            // Usuario *user = [_resultados objectAtIndex:_fichaActualIndex];
            //            [[BDServices sharedInstance]eliminaUsuario:user];
            //            [self adelante];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"denuncia", nil)  message:NSLocalizedString(@"denuncia_msg", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }else{
            error = true;
        }
    }else
        error= true;
    if(error){
        [[[UIAlertView alloc] initWithTitle:@"Upps" message:@"Error.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}


-(void)muestraQimy:(NSNotification *)not{
    _qimyVC.nombrePubli =nil;
    _qimyVC.urlPubli = nil;
    [self presentViewController:_qimyVC animated:YES completion:nil];
}

-(void)animacion:(NSNotification *)not{
    
    NSDictionary *dic = not.userInfo;
    if ([[dic objectForKey:@"resultado"] isEqualToString:@"OK"]) {
        if([[dic objectForKey:@"qimy"] isEqualToString:@"OK"]){
            Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
            [[WSService sharedInstance] getAllEncuentro:[p.idPerfil intValue]];
        }else{
            
            if(!_isFichaChat){
                if(_pulsaQimyOK)
                    _imageNOQ.image = [UIImage imageNamed:@"qimy"];
                else{
                    _imageNOQ.image = [UIImage imageNamed:@"no-qimy"];
                    //
                    //                    Usuario *user = [_resultados objectAtIndex:_fichaActualIndex];
                    //                    [[BDServices sharedInstance] eliminarEncuentros:[user.idPerfil intValue]];
                }
                _isbackActive = true;
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     _imageNOQ.alpha =1;
                                     _lgSublimer.alpha =0;
                                 } completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2
                                                      animations:^{
                                                          _imageNOQ.alpha =0;
                                                          _lgSublimer.alpha=0;
                                                      } completion:^(BOOL finished) {
                                                          [self adelante];
                                                      }];
                                 } ];
                
            }else{
                [self close:nil];
            }
        }
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Uups" message:@"Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    
}
@end
