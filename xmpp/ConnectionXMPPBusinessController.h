//
//  ConnectionXMPPBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 27/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPFramework.h"

#import "IMessageDelegate.h"
#import "IQueryDelegate.h"

#import "Protocols/IDAOUser.h"

@interface ConnectionXMPPBusinessController : NSObject
<XMPPRosterDelegate, XMPPStreamDelegate>

@property (strong, nonatomic) NSString * userPassword;

@property (strong, retain) XMPPStream * xmppStream;
@property (strong, retain) XMPPRosterCoreDataStorage * xmppRosterStorage;
@property (strong, retain) XMPPRoster * xmppRoster;

@property (weak) id<IDAOUser> daoUser;
@property (weak) id<IMessageDelegate> infoMessage;
@property (weak) id<IQueryDelegate> resultIQ;

- (BOOL) connectUser:(NSDictionary *) user;
- (void) disconnect;

@end
