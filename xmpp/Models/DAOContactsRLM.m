//
//  DAOContactsRLM.m
//  xmpp
//
//  Created by Estefania Guardado on 16/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "DAOContactsRLM.h"

@implementation DAOContactsRLM

- (id)init {
    self = [super init];
    self.oldData = [NSMutableSet setWithArray:@[
                                                @{
                                                    @"jid" : @"3pfmzjffz9tm32viob36a0e5le@public.talk.google.com",
                                                    @"name" : @"Estefania Guardado"
                                                    },
                                                @{
                                                    @"jid" : @"0z8d21t7wzim42ux8h14ol260e@public.talk.google.com",
                                                    @"name" : @"Luis Alejandro Sánchez"
                                                    },
                                                @{
                                                    @"jid" : @"0070s1ke5udxn0rwrs568oc9e1@public.talk.google.com",
                                                    @"name" : @"Rita Guardado"
                                                    },
                                                @{
                                                    @"jid" : @"1xnqzhessnhla3jv587c8qb9o9@public.talk.google.com",
                                                    @"name" : @"Maria de Lourdes Pacheco"
                                                    }
                                                ]];
    
    self.updateDa = [NSMutableSet setWithArray:@[
                                                   @{
                                                       @"jid" : @"0z8d21t7wzim42ux8h14ol260e@public.talk.google.com",
                                                       @"name" : @"Luis Alejandro Rangel Sanchez"
                                                       },
                                                   @{
                                                       @"jid" : @"0070s1ke5udxn0rwrs568oc9e1@public.talk.google.com",
                                                       @"name" : @"Rita Guardado"
                                                       },
                                                   @{
                                                       @"jid" : @"1xnqzhessnhla3jv587c8qb9o9@public.talk.google.com",
                                                       @"name" : @"María de Lourdes Pacheco"
                                                       }
                                                   ]];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)updateValues:(NSArray *)contacts{
    
    if (![self getContacts]) {
        [contacts enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * stop) {
            [self createContactInRealm:contact];
        }];
        
    } else{
        [self newUpdatesInDataContacts:contacts];
    }

}

- (void) createContactInRealm: (NSDictionary *) contact{
    ContactRLM * contactRLM = [ContactRLM new];
    
    contactRLM.jid = [contact valueForKey:@"jid"];
    contactRLM.name = [contact valueForKey:@"name"];
    
    [self.realm beginWriteTransaction];
    [self.realm addObject:contactRLM];
    [self.realm commitWriteTransaction];
}

- (NSArray *)getContacts{
    RLMResults<ContactRLM *> *results = [ContactRLM allObjectsInRealm:self.realm];
    
    if (results.count) {
        NSMutableArray * contactsResult = [NSMutableArray array];
        for (NSInteger index = 0; index < results.count; index++) {
            [contactsResult addObject:@{
                                        @"jid" : [results[index] valueForKey:@"jid"],
                                        @"name" : [results[index] valueForKey:@"name"]
                                        }];
        }
        return contactsResult;
    }
    
    return nil;
}

- (void) newUpdatesInDataContacts: (NSArray *) newDataContacts {
    
    NSMutableSet * oldSetData = [NSMutableSet setWithArray:[self getContacts]];
    NSMutableSet * newSetData = [NSMutableSet setWithSet:[self.updateDa copy]];
    
    //NSMutableSet * newSetData = [NSMutableSet setWithArray:newDataContacts];
    
    [oldSetData minusSet:newSetData];
    [newSetData minusSet:[NSMutableSet setWithArray:[self getContacts]]];
    
    if ([oldSetData count] && [newSetData count]) {
        [self compareSetContacts:oldSetData And:newSetData];
        
    } else {
        for (NSDictionary * newContact in newSetData) {
            [self createContactInRealm:newContact];
        }
        for (NSDictionary * oldContact in oldSetData) {
            [self removeContactFromRealm:oldContact];
        }
    }
}

- (void) compareSetContacts: (NSSet*) oldContacts And: (NSSet*) newContacts{
    NSMutableSet* copyNewContacts = [NSMutableSet setWithSet:newContacts];
    NSMutableSet* copyOldContacts = [NSMutableSet setWithSet:oldContacts];


    for (NSDictionary * oldContact in oldContacts) {
        for (NSDictionary * newContact in newContacts) {
            if ([self equalJid:[oldContact valueForKey:@"jid"]
                           And:[newContact valueForKey:@"jid"]]) {
                [self removeContactFromRealm:oldContact];
                [self createContactInRealm:newContact];
                
                [copyNewContacts minusSet:[NSSet setWithObject:newContact]];
                [copyOldContacts minusSet:[NSSet setWithObject:oldContact]];
            }
        }
        if (![copyNewContacts count] || ![copyOldContacts count]) {
            break;
        }
    }
    
    for (NSDictionary * contact in copyNewContacts) {
        [self createContactInRealm:contact];
    }
    for (NSDictionary * contact in copyOldContacts) {
        [self removeContactFromRealm:contact];
    }
}

- (BOOL) equalJid: (NSString*)firstJid And: (NSString*) secondJid{
    return [firstJid isEqualToString:secondJid];
}

- (void)removeContactFromRealm: (NSDictionary*) contact{
    
    ContactRLM * contactRLM = [ContactRLM new];
    contactRLM.jid = [contact valueForKey:@"jid"];
    contactRLM.name = [contact valueForKey:@"name"];
    
    [self.realm beginWriteTransaction];
    RLMResults<ContactRLM *> *results = [ContactRLM objectsInRealm:self.realm where:@"jid contains %@", [contact valueForKey:@"jid"]];
    for (ContactRLM *contact in results) {
        [self.realm deleteObject:contact];
    }
    [self.realm commitWriteTransaction];
}


@end
