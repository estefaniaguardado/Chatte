//
//  QueriesBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 04/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "QueriesBusinessController.h"
#import "XMPPFramework.h"

@implementation QueriesBusinessController

- (instancetype)init{
    if (self = [super init]) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.appDelegate.resultIQ = self;
        self.messageBusinessController = [[MessageBusinessController alloc] init];
    }
    
    return self;
}

- (void) sendIQToGetRoster {
    
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

- (void)handler:(XMPPIQ *)iq{
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    if (query && !self.didReceivedIQRoster) {
        [self formatToReceivedRoster: iq];
        self.didReceivedIQRoster = YES;
    }
}

- (NSMutableArray*) getRoster{
    return self.contactRoster;
}

-(void) formatToReceivedRoster: (XMPPIQ*) iq{

    self.contactRoster = [NSMutableArray array];
    
    NSXMLElement * query = [iq elementForName:@"query"];
    NSArray *items = [query elementsForName:@"item"];
    
    for (NSXMLElement * value in items) {
        NSDictionary * contact = @{
                                   @"name" : [[value attributeForName:@"name"] stringValue],
                                   @"jid" : [[value attributeForName:@"jid"] stringValue]
                                   };
        //XMPPJID *jid = [XMPPJID jidWithString:jidString];
        [self.contactRoster addObject:contact];
    }
    
    [self sendRosterToMessageBC];
}

-(void) sendRosterToMessageBC{
    [self.messageBusinessController getContactRoster:self.contactRoster];
}

@end
