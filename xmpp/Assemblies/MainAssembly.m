//
//  MainAssembly.m
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MainAssembly.h"

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RosterViewController.h"
#import "MessagesTableViewController.h"

#import "ConnectionXMPPBusinessController.h"
#import "RosterBusinessController.h"
#import "QueriesBusinessController.h"
#import "MessageBusinessController.h"

#import "DAOUserDefaults.h"
#import "DAOUserRLM.h"

@implementation MainAssembly
    
-(AppDelegate *)appDelegate{
    return [TyphoonDefinition withClass:[AppDelegate class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition injectProperty:@selector(window)
                              with:[self mainWindow]];
        [definition injectProperty:@selector(connectionXMPPBusinessController)
                              with:[self connectionXMPPBusinessController]];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (UIWindow *) mainWindow{
    return [TyphoonDefinition withClass:[UIWindow class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition useInitializer:@selector(initWithFrame:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:
                             [NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
                        }];
    }];
}

-(ConnectionXMPPBusinessController *) connectionXMPPBusinessController{
    return [TyphoonDefinition withClass:[ConnectionXMPPBusinessController class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition injectProperty:@selector(xmppStream) with:[self xmppStream]];
        [definition injectProperty:@selector(xmppRosterStorage)
                              with:[self xmppRosterStorage]];
        [definition injectProperty:@selector(xmppRoster) with:[self xmppRoster]];
        
        [definition injectProperty:@selector(daoUser) with:[self daoUserRLM]];
        [definition injectProperty:@selector(infoRoster)
                              with:[self rosterBusinessController]];
        [definition injectProperty:@selector(resultIQ)
                              with:[self queriesBusinessController]];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
-(XMPPStream *) xmppStream{
    return [TyphoonDefinition withClass:[XMPPStream class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

-(XMPPRoster *) xmppRoster{
    return [TyphoonDefinition withClass:[XMPPRoster class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition useInitializer:@selector(initWithRosterStorage:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self xmppRosterStorage]];
                        }];
                              
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
-(XMPPRosterCoreDataStorage *) xmppRosterStorage{
    return [TyphoonDefinition withClass:[XMPPRosterCoreDataStorage class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition useInitializer:@selector(initWithDatabaseFilename:storeOptions:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:nil];
                            [initializer injectParameterWith:nil];
                        }];
                              
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
- (DAOUserDefaults *) daoUserDefaults{
    return [TyphoonDefinition withClass:[DAOUserDefaults class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
- (LoginViewController *) loginViewController{
    return [TyphoonDefinition withClass:[LoginViewController class]
                          configuration:^(TyphoonDefinition *definition){
                              
        [definition injectProperty:@selector(connectionXMPPBusinessController)
                              with:[self connectionXMPPBusinessController]];
        [definition injectProperty:@selector(daoUser) with:[self daoUserRLM]];

        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (RosterViewController *) rosterViewController{
    return [TyphoonDefinition withClass:[RosterViewController class]
                          configuration:^(TyphoonDefinition *definition){
                              
        [definition injectProperty:@selector(daoUser) with:[self daoUserRLM]];
        [definition injectProperty:@selector(connectionXMPPBusinessController)
                              with:[self connectionXMPPBusinessController]];
        [definition injectProperty:@selector(rosterBusinessController)
                              with:[self rosterBusinessController]];
        [definition injectProperty:@selector(queriesBusinessController)
                              with:[self queriesBusinessController]];

        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (MessagesTableViewController *) messagesTableViewController{
    return [TyphoonDefinition withClass:[MessagesTableViewController class]
                          configuration:^(TyphoonDefinition *definition){
        
        [definition injectProperty:@selector(messageBusinessController)
                              with:[self messageBusinessController]];
       
        definition.scope = TyphoonScopePrototype;
    }];
}

- (RosterBusinessController *) rosterBusinessController{
    return [TyphoonDefinition withClass:[RosterBusinessController class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition injectProperty:@selector(message) with:[self xmppMessage]];

        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (XMPPMessage *) xmppMessage{
    return [TyphoonDefinition withClass:[XMPPMessage class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (QueriesBusinessController *) queriesBusinessController{
    return [TyphoonDefinition withClass:[QueriesBusinessController class]
                          configuration:^(TyphoonDefinition *definition) {
                              
        [definition injectProperty:@selector(connectionXMPPBusinessController)
                              with:[self connectionXMPPBusinessController]];
        [definition injectProperty:@selector(rosterBusinessController)
                              with:[self rosterBusinessController]];
                              
        definition.scope = TyphoonScopeLazySingleton;
        }];
}

- (DAOUserRLM *) daoUserRLM {
    return [TyphoonDefinition withClass:[DAOUserRLM class]
                          configuration:^(TyphoonDefinition *definition) {

                              [definition injectProperty:@selector(realm)
                                                    with:[self rlmRealm]];
                              
                              definition.scope = TyphoonScopeLazySingleton;
                          }];
}

- (RLMRealm *) rlmRealm{
    return [RLMRealm defaultRealm];
}

- (MessageBusinessController *) messageBusinessController{
    return [TyphoonDefinition withClass:[MessageBusinessController class]
                          configuration:^(TyphoonDefinition *definition) {

            definition.scope = TyphoonScopePrototype;
                          
                          }];
}

@end
