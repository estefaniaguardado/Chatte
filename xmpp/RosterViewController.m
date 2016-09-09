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

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.title = [[[self.appDelegate xmppStream] myJID] bare];
    
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


- (void) getRoster: (NSString *) user{
    
    
    NSXMLElement *xmlns = [NSXMLElement elementWithName:@"query"];
    [xmlns addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    [xmlns addAttributeWithName:@"xmlns:gr" stringValue:@"google:roster"];
    [xmlns addAttributeWithName:@"gr:ext" stringValue:@"2"];


    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    //[iq addAttributeWithName:@"to" stringValue:user];
    [iq addAttributeWithName:@"from" stringValue:[[[self.appDelegate xmppStream] myJID] full]];
    [iq addAttributeWithName:@"id" stringValue:@"v1"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:xmlns];
    
    [[self.appDelegate xmppStream] sendElement:iq];

//    <iq type='get'
//    from='romeo@gmail.com/orchard'
//    id='google-roster-1'>
//    <query xmlns='jabber:iq:roster' xmlns:gr='google:roster' gr:ext='2'/>
//    </iq>
    
//    NSXMLElement *xmlns = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
//    [iq addAttributeWithName:@"to" stringValue:user];
//    [iq addAttributeWithName:@"from" stringValue:[[[self.appDelegate xmppStream] myJID] full]];
//    [iq addAttributeWithName:@"id" stringValue:@"v1"];
//    [iq addAttributeWithName:@"type" stringValue:@"get"];
//    [iq addChild:xmlns];
//    
//    [[self.appDelegate xmppStream] sendElement:iq];
    
    //        <iq from='stpeter@jabber.org/roundabout'
    //        id='v1'
    //        type='get'>
    //        <vCard xmlns='vcard-temp'/>
    //        </iq>
}

@end
