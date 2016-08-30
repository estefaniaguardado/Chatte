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
@property (weak) XMPPStream * xmppStrem;
@property (weak) XMPPRosterCoreDataStorage * xmppRosterStorage;
@property (weak) XMPPRoster * xmppRoster;

@end

