//
//  AppDelegate.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@protocol ChatDelegate

- (void) buddyWentOnline: (NSString *) name;
- (void) buddyWentOffline: (NSString *) name;
- (void) didDisconnect;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, XMPPStreamDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak) id<ChatDelegate> delegate; //var delegate:ChatDelegate! = nil
@property (strong, retain) XMPPStream * xmppStream;
@property (strong, retain) XMPPRosterCoreDataStorage * xmppRosterStorage;
@property (strong, retain) XMPPRoster * xmppRoster;
@property (strong, nonatomic) NSString * userPassword;

- (BOOL) connect;

@end

