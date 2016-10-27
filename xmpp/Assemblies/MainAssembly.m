//
//  MainAssembly.m
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MainAssembly.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "RosterViewController.h"

#import "MessageBusinessController.h"
#import "QueriesBusinessController.h"

#import "DAOUserDefaults.h"

@implementation MainAssembly
    
-(AppDelegate *)appDelegate{
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(xmppStream) with:[self xmppStream]];
        [definition injectProperty:@selector(xmppRosterStorage) with:[self xmppRosterStorage]];
        [definition injectProperty:@selector(xmppRoster) with:[self xmppRoster]];
        
        [definition injectProperty:@selector(infoUser) with:[self daoUserDefaults]];
        [definition injectProperty:@selector(infoMessage) with:[self messageBusinessController]];
        [definition injectProperty:@selector(resultIQ) with:[self queriesBusinessController]];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
-(XMPPStream *) xmppStream{
    return [TyphoonDefinition withClass:[XMPPStream class] configuration:^(TyphoonDefinition *definition) {
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

-(XMPPRoster *) xmppRoster{
    return [TyphoonDefinition withClass:[XMPPRoster class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithRosterStorage:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self xmppRosterStorage]];
                        }];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
-(XMPPRosterCoreDataStorage *) xmppRosterStorage{
    return [TyphoonDefinition withClass:[XMPPRosterCoreDataStorage class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDatabaseFilename:storeOptions:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:nil];
                            [initializer injectParameterWith:nil];
                        }];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
- (DAOUserDefaults *) daoUserDefaults{
    return [TyphoonDefinition withClass:[DAOUserDefaults class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeLazySingleton;
    }];
}
    
- (ViewController *) viewController{
    return [TyphoonDefinition withClass:[ViewController class] configuration:^(TyphoonDefinition *definition){
        [definition injectProperty:@selector(appDelegate) with:[self appDelegate]];
        [definition injectProperty:@selector(daoUser) with:[self daoUserDefaults]];
        
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (RosterViewController *) rosterViewController{
    return [TyphoonDefinition withClass:[RosterViewController class]
                          configuration:^(TyphoonDefinition *definition){
        [definition injectProperty:@selector(appDelegate) with:[self appDelegate]];
        [definition injectProperty:@selector(messageBusinessController)
                              with:[self messageBusinessController]];
        [definition injectProperty:@selector(queriesBusinessController)
                              with:[self queriesBusinessController]];

        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (MessageBusinessController *) messageBusinessController{
    return [TyphoonDefinition withClass:[MessageBusinessController class]
                          configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(appDelegate) with:[self appDelegate]];
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
        [definition injectProperty:@selector(appDelegate) with:[self appDelegate]];
        [definition injectProperty:@selector(messageBusinessController)
                              with:[self messageBusinessController]];
        definition.scope = TyphoonScopeLazySingleton;
        }];
}

@end
