//
//  DAOContactsRLM.m
//  xmpp
//
//  Created by Estefania Guardado on 16/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "DAOContactsRLM.h"

@implementation DAOContactsRLM

- (void)updateValues:(NSArray *)contacts{
    
    if (![self getContacts]) {
        [contacts enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * stop) {
            ContactRLM * contactRLM = [ContactRLM new];
            
            contactRLM.jid = [contact valueForKey:@"jid"];
            contactRLM.name = [contact valueForKey:@"name"];
            
            [self.realm beginWriteTransaction];
            [self.realm addObject:contactRLM];
            [self.realm commitWriteTransaction];
        }];
    }
    
}

- (NSArray *)getContacts{
    RLMResults<ContactRLM *> *results = [ContactRLM allObjectsInRealm:self.realm];
    
    if (results.count) {
        return [NSArray arrayWithObject:results];
    }
    
    return nil;
}

@end
