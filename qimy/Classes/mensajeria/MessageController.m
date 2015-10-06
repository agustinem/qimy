//
//  MessageController.m
//  Whatsapp
//
//  Created by Rafael Castro on 7/23/15.
//  Copyright (c) 2015 HummingBird. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
#import "TableArray.h"
#import "MessageGateway.h"
#import "WSService.h"
#import "Inputbar.h"
#import "Constants.h"
#import "DAKeyboardControl.h"
#import "Util.h"

@interface MessageController() <InputbarDelegate,MessageGatewayDelegate,
                                    UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  Inputbar *inputbar;
@property (strong, nonatomic) TableArray *tableArray;
@property (strong, nonatomic) MessageGateway *gateway;
@property NSString *textAuxSend;
@end




@implementation MessageController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setTableView];
    [self setInputbar];
    [self setGateway];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mensajeEnviado:) name:kNotificationUltimoMensaje object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak Inputbar *inputbar = _inputbar;
    __weak UITableView *tableView = _tableView;
    __weak MessageController *controller = self;
    
    self.view.keyboardTriggerOffset = inputbar.frame.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = inputbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        inputbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y - 10;
        tableView.frame = tableViewFrame;
        
        [controller tableViewScrollToBottomAnimated:NO];
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [self.view removeKeyboardControl];
    [self.gateway dismiss];
}
-(void)viewWillDisappear:(BOOL)animated
{
   // self.chat.last_message = [self.tableArray lastObject];
}

#pragma mark -

-(void)setInputbar
{
    _inputbar = [[Inputbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];

    self.inputbar.placeholder = nil;
    self.inputbar.delegate = self;
//    self.inputbar.leftButtonImage = [UIImage imageNamed:@"share"];
    self.inputbar.rightButtonText = NSLocalizedString(@"boton_enviar", nil);
    self.inputbar.rightButtonTextColor = [UIColor colorWithRed:0 green:124/255.0 blue:1 alpha:1];
    
    [self.view addSubview:_inputbar];

}

-(void)setTableView
{
    self.tableArray = [[TableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-100)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, 10.0f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    [self.view addSubview:_tableView];
//set caebcera
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,100)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [headerView addSubview:imageView];
    imageView.layer.cornerRadius =  40;
    imageView.layer.borderWidth=3.0;
    imageView.layer.borderColor= [UIColor whiteColor].CGColor;
    imageView.clipsToBounds = YES;
    imageView.contentMode= UIViewContentModeScaleAspectFill;
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, 200, 33)];
    labelView.textColor = [Util colorFromHexString:@"7cba35"];
    labelView.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [headerView addSubview:labelView];
    imageView.image = _imageUser;
    labelView.text = _nombre;
   // self.tableView.tableHeaderView = headerView;

    CGFloat yPosition = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;

    const CGFloat mainHeaderHeight = 44;
    
    [self.tableView.superview addSubview:headerView];
    [self.tableView setContentInset:UIEdgeInsetsMake(yPosition + mainHeaderHeight, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];

    

}


-(void)setGateway
{
    self.gateway = [MessageGateway sharedInstance];
    self.gateway.delegate = self;
    self.gateway.chat = self.chat;
    [self.gateway loadOldMessages];

}
-(void)setChat:(Chat *)chat
{
    _chat = chat;
    self.title = chat.sender_name;
}

#pragma mark - Actions

- (IBAction)userDidTapScreen:(id)sender
{
    [_inputbar resignFirstResponder];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableArray numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray numberOfMessagesInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.message = [self.tableArray objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.tableArray objectAtIndexPath:indexPath];
    return message.heigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableArray titleForSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor =    [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    [label sizeToFit];
    label.center = view.center;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    label.backgroundColor = [UIColor colorWithRed:207/255.0 green:220/255.0 blue:252.0/255.0 alpha:1];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    
    return view;
}
- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    NSInteger numberOfSections = [self.tableArray numberOfSections];
    NSInteger numberOfRows = [self.tableArray numberOfMessagesInSection:numberOfSections-1];
    if (numberOfRows)
    {
        [_tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                                         atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - InputbarDelegate

-(void)mensajeEnviado:(NSNotification *)not{
    Message *message = [[Message alloc] init];
    message.text = _textAuxSend;
    message.date = [NSDate date];
    message.chat_id = _chat.identifier;
    
    //Store Message in memory
    [self.tableArray addObject:message];
    
    //Insert Message in UI
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    [self.tableView beginUpdates];
    if ([self.tableArray numberOfMessagesInSection:indexPath.section] == 1)
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:[self.tableArray indexPathForLastMessage]
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //Send message to server
    [self.gateway sendMessage:message];
}

-(void)inputbarDidPressRightButton:(Inputbar *)inputbar
{
    NSDate * date = [NSDate date];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.timeZone = tz;
    dateFormat.dateFormat = kBDDateFormat;    
    NSString *dateStr = [dateFormat stringFromDate:date];
    
    _textAuxSend = inputbar.text;
    [[WSService sharedInstance]editMessage:[_chat.sender_id intValue]  envioAId:[_chat.last_message.chat_id intValue] match:[_chat.identifier intValue] fecha:dateStr mensaje:inputbar.text];
   
}
-(void)inputbarDidPressLeftButton:(Inputbar *)inputbar
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Left Button Pressed"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//    [alertView show];
}
-(void)inputbarDidChangeHeight:(CGFloat)new_height
{
    //Update DAKeyboardControl
    self.view.keyboardTriggerOffset = new_height +50;
}

#pragma mark - MessageGatewayDelegate

-(void)gatewayDidUpdateStatusForMessage:(Message *)message
{
    NSIndexPath *indexPath = [self.tableArray indexPathForMessage:message];
    MessageCell *cell = (MessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateMessageStatus];
}
-(void)gatewayDidReceiveMessages:(NSArray *)array
{
    [self.tableArray addObjectsFromArray:array];
    [self.tableView reloadData];
}



@end
