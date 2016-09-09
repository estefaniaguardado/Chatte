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
    self.appDelegate.resultIQ = self;
    
    self.contactRoster = [NSMutableArray array];
    
    [self getRoster];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.title = [[[self.appDelegate xmppStream] myJID] bare];
    
}


- (void)buddyWentOnline:(NSString *)name{
    //[self.tableView reloadData];
}

- (void)buddyWentOffline:(NSString *)name{
    //[self.tableView reloadData];
}

- (void)didDisconnect{
    [self.tableView reloadData];
}

- (void)didReceiveIQ:(XMPPIQ *)iq{

    NSXMLElement * query = [iq elementForName:@"query"];
    NSArray *items = [query elementsForName:@"item"];
    
    for (NSXMLElement * value in items) {
        NSDictionary * contact = @{
                                   @"name" : [value attributeStringValueForName:@"name"],
                                   @"jid" : [value attributeStringValueForName:@"jid"]
                                   };
        //XMPPJID *jid = [XMPPJID jidWithString:jidString];
        [self.contactRoster addObject:contact];
    }
}

- (void) getRoster {
    
    NSXMLElement *xmlns = [NSXMLElement elementWithName:@"query"];
    [xmlns addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    [xmlns addAttributeWithName:@"xmlns:gr" stringValue:@"google:roster"];
    [xmlns addAttributeWithName:@"gr:ext" stringValue:@"2"];
    
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"from" stringValue:[[[self.appDelegate xmppStream] myJID] full]];
    [iq addAttributeWithName:@"id" stringValue:@"v1"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:xmlns];
    
    [[self.appDelegate xmppStream] sendElement:iq];
}


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

@end
