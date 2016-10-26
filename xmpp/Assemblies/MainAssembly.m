//
//  MainAssembly.m
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MainAssembly.h"

#import "AppDelegate.h"

@implementation MainAssembly
    
-(AppDelegate *)appDelegate{
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(xmppStream) with:[self xmppStream]];
        [definition injectProperty:@selector(xmppRoomStorage) with:[self xmppRosterStorage]];
        [definition injectProperty:@selector(xmppRoster) with:[self xmppRoster]];

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

@end
