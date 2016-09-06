//
//  AppDelegate.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "CocoaLumberjack_Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (id) init{
    
    self = [super init];
    
    self.xmppStream = [XMPPStream new];
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
    //self.xmppRoster = [[XMPPRoster new] initWithRosterStorage:self.xmppRosterStorage];
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [self setupStream];
    //[self connect];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connect];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//MARK: Private Methods
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

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (BOOL) connect {
    [self setupStream];
    if (![self.xmppStream isDisconnected]) return YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jabberID = [defaults objectForKey:@"userID"];
    NSString * myPassword = [defaults objectForKey:@"userPassword"];
    
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    if ([jabberID isEqual: nil] && [myPassword isEqual: nil]) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    self.userPassword = [NSString stringWithString:myPassword];
    
    NSError *error = nil;
    if (![self.xmppStream connectWithTimeout:20 error:&error]) {
        NSLog(@"Impossible to connect %@", error.localizedDescription);
        return NO;
    }
    
    NSLog(@"connected");
    return YES;
}

- (void) disconnect {
    [self goOffline];
    [self.xmppStream disconnect];
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

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // authentication successful
    [self goOnline];
}

- (BOOL) xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSLog(@"Did receive IQ");
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    [self.infoMessage handler:message];
    //NSLog(@"Did receive message: %@", message);
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"Did receive message: %@", message);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSString * presenceType = [NSString stringWithString:presence.type];
    NSString * myUserName = [NSString stringWithString:sender.myJID.user];
    NSString * presenceFromUser = [NSString stringWithString:presence.from.user];
    
    if (presenceFromUser != myUserName) {
        NSLog(@"Did receive presence from: %@", presenceFromUser);
        if ([presenceType isEqualToString: @"available"]) {
            [self.delegate buddyWentOnline:[presenceFromUser stringByAppendingString:@"@gmail.com"]];
        } else if ([presenceType isEqualToString: @"unavailable"]){
            [self.delegate buddyWentOffline:[presenceFromUser stringByAppendingString:@"@gmail.com"]];
        }
    }

}

@end