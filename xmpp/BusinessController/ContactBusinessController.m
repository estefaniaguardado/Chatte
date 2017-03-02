//
//  ContactBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 22/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ContactBusinessController.h"

@implementation ContactBusinessController

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerIQ:)
                                                 name:@"IQroster" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerPresence:)
                                                 name:@"presenceContact" object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void) handlerIQ:(NSNotification*) notification{
    NSArray *contacts = [self.daoContact getContacts];
    NSMutableSet * oldSetData = [NSMutableSet setWithArray:contacts];
    
    NSArray * updateContacts = [[notification userInfo] objectForKey:@"contacts"];
    
    [self.daoContact updateValues:updateContacts];
    
    NSMutableSet * newSetData = [NSMutableSet setWithArray:updateContacts];
    
    [oldSetData minusSet:newSetData];
    [newSetData minusSet:[NSMutableSet setWithArray:contacts]];
    
    if ([oldSetData count] || [newSetData count]) {
        NSDictionary * indexContacts = [self.updateValuesHandler
                                        calculateArrayIndexOfContacts:contacts And:updateContacts];
        [self.handler updateValuesWith:indexContacts];
    }
}

- (void) handlerPresence:(NSNotification*) notification{
    NSArray *contacts = [self.daoContact getContacts];
    
    NSDictionary * presenceContact = [notification userInfo];
    NSMutableArray * newContacts = [NSMutableArray arrayWithArray:contacts];
    
    for (int index = 0; index < contacts.count; index++) {
        if ([[contacts[index] valueForKey:@"jid"] isEqualToString:[presenceContact valueForKey:@"from"]]) {
            NSMutableDictionary * copyContact = [NSMutableDictionary dictionaryWithDictionary:contacts[index]];
            [copyContact setValue:[presenceContact valueForKey:@"status"] forKey:@"status"];
            
            [newContacts removeObjectAtIndex:[[NSNumber numberWithInt:index] integerValue]];
            [newContacts insertObject:copyContact atIndex:[[NSNumber numberWithInt:index] integerValue]];
            
            NSMutableSet * oldSetData = [NSMutableSet setWithArray:contacts];
            
            //[self.daoContact updateValues:[NSArray arrayWithArray:newContacts]];
            NSMutableSet * newSetData = [NSMutableSet setWithArray:newContacts];
            
            [oldSetData minusSet:newSetData];
            [newSetData minusSet:[NSMutableSet setWithArray:contacts]];

            NSDictionary * indexContacts = [self.updateValuesHandler
                                            calculateArrayIndexOfContacts:contacts And:newContacts];
            [self.handler updateStatus:[indexContacts valueForKey:@"update"] ofContact:copyContact];
            
            break;
        }
    }
}

@end
