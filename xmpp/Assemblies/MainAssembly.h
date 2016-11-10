//
//  MainAssembly.h
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Typhoon/Typhoon.h>

#import "XMPPFramework.h"

@class AppDelegate;
@class LoginViewController;
@class RosterViewController;
@class ChatTableViewController;
@class ChatViewController;

@interface MainAssembly : TyphoonAssembly
    
- (AppDelegate *) appDelegate;
- (LoginViewController *) loginViewController;
- (RosterViewController *) rosterViewController;
- (ChatTableViewController *) chatTableViewController;
- (ChatViewController *) chatViewController;
- (UIWindow *) mainWindow;

@end
