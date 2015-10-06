//
//  QimyTableViewController.m
//  qimy
//
//  Created by Agustín Embuena on 28/7/15.
//  Copyright (c) 2015 Agustín Embuena. All rights reserved.
//
#import <KVNProgress/KVNProgress.h>
#import "QimyTableViewController.h"
#import "MessageController.h"
#import "MessageGateway.h"
#import "EncuentroCell.h"
#import "Constants.h"
#import "BDServices.h"
#import "WSService.h"
#import "Perfil.h"
#import "Encuentro.h"
#import "ResultadoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ConsultaMensaje.h"
#import "Chat.h"
#import "Mensaje.h"
#import "LocalStorage.h"

@interface QimyTableViewController ()
@property NSArray *listEncuentros;
@property BOOL bannerIsVisible;
@property ADBannerView *adBanner;
@property  UIView * viewContentIAD ;
@property float heightAdView;
@property int idEncuentro;
@property (strong, nonatomic) NSMutableArray *tableData;
@property  NSNumber * idUser;
@property NSString *nombreUser;
@property UIImage *imageUser;
@property NSIndexPath *indexElimina;

@end

@implementation QimyTableViewController

-(void)fichaChat:(NSNotification *)not{
    int idUser = [[not.userInfo objectForKey:@"idFicha"] intValue];
    [[WSService sharedInstance]getUsuarioById:idUser];
}

-(void)cargaResultado:(NSNotification *)not{
    ResultadoViewController *resultado = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"resultado"];
    resultado.isFichaChat = true;
    resultado.resultados = [[BDServices sharedInstance]obtenerUsuarios];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cambiarChat" object:nil];
    [self presentViewController:resultado animated:YES completion:nil];
}

//-(void)mensajeEnviado:(NSNotification *)not{
//    [self cargaEncuentros];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cargaChat:) name:kNotificationTodosMensajes object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mensajeEnviado:) name:kNotificationUltimoMensaje object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLista:) name:kNotificationEncuentros object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fichaChat:) name:kNotificationFichaChat object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cargaResultado:) name:kNotificationUserid object:nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.023 green:0.205 blue:0.163 alpha:1.000];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(cargaEncuentros)
                  forControlEvents:UIControlEventValueChanged];
    
}

-(void)cargaEncuentros{
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    [[WSService sharedInstance] getAllEncuentro:[p.idPerfil intValue]];
    
}

-(void)cargaChat:(NSNotification *)not{
    //crear los chat antes de pasar;
    [self performSegueWithIdentifier:@"chat" sender:nil];
    
}

-(void)getLista:(NSNotification *)not{
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Última actualización: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }

    _listEncuentros = [[BDServices sharedInstance] obtenerEncuentros];
    [KVNProgress dismiss];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
   _listEncuentros = [[BDServices sharedInstance] obtenerEncuentros];
}

-(void)viewDidAppear:(BOOL)animated{
    [self cargaEncuentros];
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
    if(_listEncuentros == nil){
        [[[UIAlertView alloc] initWithTitle:@"Upps" message:@"Refresh!" delegate:nil cancelButtonTitle:@"Refresh" otherButtonTitles: nil] show];
        return 0;
        
    }
    return [_listEncuentros count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EncuentroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"encuentroCell" forIndexPath:indexPath];
    Encuentro *encuentro = [_listEncuentros objectAtIndex:indexPath.row];
    [cell.fotoPrincipal sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_grande.jpg",URLImages,encuentro.fotoPrincipal]]  placeholderImage:[UIImage imageNamed:@"no-img"]];
    NSArray *ultimoMensajeElements = [encuentro.ultimoMensaje componentsSeparatedByString:@"**"];
    if([ultimoMensajeElements count] ==3){
    _nombreUser= [ultimoMensajeElements objectAtIndex:0];
    NSString *nombreUltimoMensaje=[ultimoMensajeElements objectAtIndex:1];
    NSString *ultimomensaje=[ultimoMensajeElements objectAtIndex:2];
        cell.mensaje.text = ultimomensaje;
        cell.fecha.text = [[nombreUltimoMensaje stringByAppendingString:@", "] stringByAppendingString: encuentro.fechaUltimoMensaje];

    }else{
        _nombreUser = encuentro.ultimoMensaje;
        cell.fecha.text = encuentro.fechaUltimoMensaje;
        cell.mensaje.text=_nombreUser;
    }
    cell.userID = [encuentro.idUser integerValue];
    cell.encuentroID = [encuentro.idEncuentro integerValue];
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:184.0/255.0 green:220.0/255.0 blue:145.0/255.0 alpha:1.0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EncuentroCell *cell = (EncuentroCell *)[tableView cellForRowAtIndexPath:indexPath];
    _idUser = [[NSNumber alloc] initWithInteger:cell.userID];
    _imageUser = cell.fotoPrincipal.image;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    _idEncuentro = (int)cell.encuentroID;
    Encuentro *encuentroSelect = [_listEncuentros objectAtIndex:indexPath.row];
    NSArray *ultimoMensajeElements = [encuentroSelect.ultimoMensaje componentsSeparatedByString:@"**"];
    _nombreUser= [ultimoMensajeElements objectAtIndex:0];

   // ConsultaMensaje *cm = [[BDServices sharedInstance]obtenerConsulta:(int)cell.encuentroID];
    //nunca se ha consultado para este usuario
//    if(cm==nil){
        [[WSService sharedInstance]getAllMessages:[p.idPerfil intValue] envioAId:(int)cell.userID match:(int)cell.encuentroID  lastID:0 fechaUltima:@""];
//    }else{
//        [[WSService sharedInstance]getAllMessages:[p.idPerfil intValue] envioAId:(int)cell.userID match:(int)cell.encuentroID  lastID:[cm.lastid intValue]   fechaUltima:cm.fecha];
//    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    MessageController *mC = (MessageController *)[segue destinationViewController];
    Chat *chat = [[Chat alloc] init];
    NSArray *conversacion = [[BDServices sharedInstance]obtenerMensajes:_idEncuentro];
    NSMutableArray *arrayMensajes = [[NSMutableArray alloc]init];
    Message *last_message = [[Message alloc] init];
    last_message.chat_id = [_idUser stringValue];
    for (Mensaje *mensaje in conversacion){
            Message *message = [[Message alloc] init];
            message.text = mensaje.mensaje;
            if([mensaje.idEmisor intValue]== [p.idPerfil intValue])
                message.sender = MessageSenderMyself;
            else
                message.sender = MessageSenderSomeone;
            message.status = MessageStatusReceived;
            message.chat_id = [NSString stringWithFormat:@"%d", [mensaje.idEncuentro intValue]] ;
            [arrayMensajes addObject:message];
    }
    [[LocalStorage sharedInstance]storeMessages:arrayMensajes];
    chat.sender_id = [p.idPerfil stringValue];
    chat.receiver_id = [NSString stringWithFormat:@"%d", _idEncuentro] ;
    chat.numberOfUnreadMessages = conversacion.count;
    chat.last_message = last_message;
    mC.chat = chat;
    mC.imageUser = _imageUser;
    mC.nombre =_nombreUser;
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
    _heightAdView = tablaH  - 90*[_listEncuentros count] ;
    if(_heightAdView<=50){
        _heightAdView =50;
        
    }
    return  _heightAdView;
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


#pragma mark -delete button cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexElimina = indexPath;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"eliminarButton", nil) message:NSLocalizedString(@"notifica_incompatibilidadd", nil) delegate:self cancelButtonTitle:@"NO" otherButtonTitles:NSLocalizedString(@"eliminarButton", nil), nil];
    alert.delegate= self;
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1)
       [self confirmaElimina];
}

-(void)confirmaElimina{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eliminado:) name:kNotificationQimy object:nil];
    Perfil *p = [[BDServices sharedInstance]obtenerPerfil];
    EncuentroCell *cell = (EncuentroCell *)[self.tableView cellForRowAtIndexPath:_indexElimina];
    [[WSService sharedInstance] editEncuentro:[p.idPerfil intValue] envioAId:(int)cell.userID qimy:0];
    NSLog(@"Deleted ");

}

-(void)eliminado:(NSNotification *)not{
    [self cargaEncuentros];
    
}

@end
