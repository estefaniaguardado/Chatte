//
//  ConnectionXMPPBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 27/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ConnectionXMPPBusinessController.h"

@implementation ConnectionXMPPBusinessController

- (BOOL) connectUser:(NSDictionary *) user {
    if (![self.xmppStream isDisconnected]) return YES;
    
    NSString *jabberID = [user valueForKey:@"userID"];
    NSString * myPassword = [user valueForKey:@"userPassword"];
    
    if (!jabberID || !myPassword) return NO;
    
    [self setupStream];
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    self.userPassword = [NSString stringWithString:myPassword];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:20 error:&error]) {
        NSLog(@"Impossible to connect %@", error.localizedDescription);
        return NO;
    }
    
    [self.daoUser updateValues:user];
    NSLog(@"connected");
    return YES;
}

-(void) setupStream {
    //xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
    [self.xmppRoster activate:self.xmppStream];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster addDelegate:self delegateQueue: dispatch_get_main_queue()];
}

-(void) goOnline {
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    NSString * domain = [NSString stringWithString:self.xmppStream.myJID.domain];
    
    if ([domain isEqualToString:@"gmail.com"] || [domain isEqualToString:@"gtalk.com"] || [domain isEqualToString:@"talk.google.com"]) {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        NSXMLElement *available = [NSXMLElement elementWithName:@"type" stringValue:@"available"];
        [presence addChild:priority];
        [presence addChild:available];
    }
    
    [self.xmppStream sendElement:presence];
}

- (void) disconnect {
    [self goOffline];
    [self.xmppStream disconnect];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

//MARK: XMPP Delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    // connection to the server successful
    //self.chatIsOpen = YES;
    NSError *error;
    
    if (![[self xmppStream] authenticateWithPassword:self.userPassword error:&error]) {
        NSLog(@"Error authenticating: %@", error);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%@", error);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // authentication successful
    [self goOnline];
}

- (BOOL) xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    [self.resultIQ handler:iq];
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    if ([message isChatMessageWithBody]){
        [self.infoRoster handler:message];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationMessage"
                                                            object:nil
                                                          userInfo:[self getDictionaryFromStanza:message]];
    }
}

- (NSDictionary *) getDictionaryFromStanza: (XMPPElement *) stanza{
    return @{
             @"id": [[stanza attributeForName:@"id"] stringValue],
             @"from": [[stanza attributeForName:@"from"] stringValue],
             @"body": [[stanza elementForName:@"body"] stringValue]
             };
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"Did receive message: %@", message);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}

@end
