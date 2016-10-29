//
//  DAOUser.m
//  xmpp
//
//  Created by Estefania Guardado on 29/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "DAOUserRLM.h"

#import "MainAssembly.h"
#import "UserRLM.h"

@implementation DAOUserRLM

- (void)updateValues: (NSDictionary*) user{
    
    UserRLM * userRLM = [UserRLM new];
    
    userRLM.jid = [user valueForKey:@"userID"];
    userRLM.password = [user valueForKey:@"userPassword"];
    
    [self.realm beginWriteTransaction];
    [self.realm addObject:userRLM];
    [self.realm commitWriteTransaction];
}

- (NSDictionary *) getUser {
    RLMResults<UserRLM *> *results = [UserRLM allObjectsInRealm:self.realm];
    if(results.count){
        return @{
                 @"userID": results[0].jid,
                 @"userPassword": results[0].password
                 };
    }
    return nil;
}

@end
