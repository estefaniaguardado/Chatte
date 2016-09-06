//
//  RosterViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "RosterViewController.h"

@implementation RosterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.appDelegate.delegate = self;
    self.appDelegate.infoMessage = self;
    //self.appDelegate = [AppDelegate new];

    self.viewModel = [NSArray array];
    self.onlineBuddies = [NSMutableSet set];
    self.messagesArray = [NSMutableArray array];
    self.messagesRegistered = [NSMutableSet set];

    [self updateViewModel];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] != nil) {
        if ([self.appDelegate connect]) {
            self.title = [[[self.appDelegate xmppStream] myJID] bare];
            [[self.appDelegate xmppRoster] fetchRoster];
            //[self getListRooms];
        }
    } else {
        [self performSegueWithIdentifier:@"Home.To.Login" sender:self];
    }
    
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.messagesArray enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:message];
        
        [viewModel addObject:@{
                               @"nib" : @"MessageTableViewCell",
                               @"height" : @(70),
                               @"data":cellModel }];
    }];
    
    self.viewModel = [NSArray arrayWithArray:viewModel];
    
    [self registerNibs];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

- (void) registerNibs{
    __weak UITableView * tableView = self.tableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
}

- (void) handler:(XMPPMessage *)message{
    //NSLog(@"%@", message.body);
    //NSLog(@"%@", message.elementID);

    if ([self isValid:message]) {
        [self.messagesRegistered addObject:[[message attributeForName:@"id"] stringValue]];
        
        NSDictionary * detailMessage = @{
                                         @"id": [[message attributeForName:@"id"] stringValue],
                                         @"from": [[message attributeForName:@"from"] stringValue],
                                         @"body": [[message elementForName:@"body"] stringValue]
                                         };
        [self.messagesArray addObject:detailMessage];
        
        [self updateViewModel];
        
        [self send:message to:[message from]];
    }
}

- (BOOL) isValid: (XMPPMessage *) message{
    BOOL messageNotRegistered = [self.messagesRegistered
                                  containsObject:[[message attributeForName:@"id"]
                                                  stringValue]] ? NO : YES;
    
    BOOL messageNotNill = [[message elementsForName:@"body"]
                           isEqualToArray:@[]] ? NO : YES;
    
    return messageNotRegistered && messageNotNill;
}

- (void) send:(XMPPMessage *)message to: (XMPPJID *) receiver{
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[[message elementForName:@"body"] stringValue]];
    
    NSXMLElement *xmppMessage = [NSXMLElement elementWithName:@"message"];
    [xmppMessage addAttributeWithName:@"type" stringValue:@"chat"];
    [xmppMessage addAttributeWithName:@"to" stringValue:[receiver full]];
    [xmppMessage addChild:body];
    
    [[self.appDelegate xmppStream] sendElement:xmppMessage];
}

//- (void) getListRooms{
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *jabberID = [defaults objectForKey:@"userID"];
//    NSString* server = @"gmail.com"; //or whatever the server address for muc is
//    XMPPJID *serverJID = [XMPPJID jidWithString:server];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:serverJID];
//    [iq addAttributeWithName:@"id" stringValue:@"124f35"];
//    [iq addAttributeWithName:@"from" stringValue:[[self.appDelegate xmppStream] myJID].full];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
//    [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];
//    [iq addChild:query];
//    [[self.appDelegate xmppStream] sendElement:iq];
//
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.onlineBuddies.count;
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    //cell.textLabel.text = [self.onlineBuddies[indexPath.row] string];
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

- (void)buddyWentOnline:(NSString *)name{
    [self.onlineBuddies addObject:[NSString stringWithString:name]];
    //[self.tableView reloadData];
}

- (void)buddyWentOffline:(NSString *)name{
    [self.onlineBuddies removeObject:name];
    //[self.tableView reloadData];
}

- (void)didDisconnect{
    [self.onlineBuddies removeAllObjects];
    [self.tableView reloadData];
}

@end
