//
//  AppDelegate.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "IMessageDelegate.h"
#import "IQueryDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate, XMPPStreamDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) XMPPStream * xmppStream;
@property (strong, retain) XMPPRosterCoreDataStorage * xmppRosterStorage;
@property (strong, retain) XMPPRoster * xmppRoster;
@property (strong, nonatomic) NSString * userPassword;

@property (weak) id<IMessageDelegate> infoMessage;
@property (weak) id<IQueryDelegate> resultIQ;

- (BOOL) connect;

@end

