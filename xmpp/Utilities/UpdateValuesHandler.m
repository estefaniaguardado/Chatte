//
//  UpdateValuesHandler.m
//  xmpp
//
//  Created by Estefania Guardado on 25/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UpdateValuesHandler.h"

@implementation UpdateValuesHandler

- (void)updateValues:(NSArray *)oldDataContact With:(NSArray *)newDataContact{
    
    [self calculateArrayIndexOfContacts:oldDataContact And:newDataContact];
}

-(void) calculateArrayIndexOfContacts:(NSArray*)oldContacts And:(NSArray*)newContacts{
    self.oldContacts = [NSMutableArray arrayWithArray:oldContacts];
    self.recentContacts = [NSMutableArray arrayWithArray:newContacts];
    
    NSMutableSet * oldSetData = [NSMutableSet setWithArray:self.oldContacts];
    NSMutableSet * newSetData = [NSMutableSet setWithArray:self.recentContacts];
    
    [oldSetData minusSet:newSetData];
    [newSetData minusSet:[NSMutableSet setWithArray:self.oldContacts]];
    
    self.addNewContacts = [NSMutableArray array];
    self.deleteContacts = [NSMutableArray array];
    self.updateContacts = [NSMutableArray array];
    
    if ([oldSetData count] && [newSetData count]) {
        [self compareSetContacts:oldSetData And:newSetData];
        
    } else {
        for (int index = 1; index <= newSetData.count; index++){
            //add new contact
            NSNumber * number = [NSNumber numberWithInt:(int)self.oldContacts.count + index];
            [self.addNewContacts addObject:number];
        }
        
        NSMutableSet * oldContacts = [NSMutableSet setWithArray:self.oldContacts];
        if ([oldSetData count] && ![oldContacts isEqualToSet:oldSetData]) {
            [self evalueOldDataContactsWith:oldSetData];
        }
    }
}

- (NSArray *) getContactsForDelete{
    return self.deleteContacts;
}

- (NSArray *) getContactsForAdd{
    return self.addNewContacts;
}

- (NSArray *) getContactsForRefresh{
    return self.updateContacts;
}

- (void) compareSetContacts: (NSSet*) oldContacts And: (NSSet*) newContacts{
    
    for (NSDictionary *oldContact in oldContacts) {
        for (NSDictionary * newContact in newContacts) {
            
            if ([self equalJid:[oldContact valueForKey:@"jid"] And:[newContact valueForKey:@"jid"]]) {
                
                for (int index = 0; index < self.oldContacts.count; index++) {
                    NSString * jidOld = [self.oldContacts[index] valueForKey:@"jid"];
                    
                    if ([self equalJid:jidOld And:[newContact valueForKey:@"jid"]]) {
                        NSNumber * number = [NSNumber numberWithInt:index];
                        [self.updateContacts addObject:number];
                        break;
                    }
                }
            }
        }
    }
}

- (BOOL) equalJid: (NSString*)firstJid And: (NSString*) secondJid{
    return [firstJid isEqualToString:secondJid];
}

- (void) evalueOldDataContactsWith: (NSSet*) oldSetData{
    
    for (NSDictionary * contact in oldSetData){
        for (int index = 0; index < self.oldContacts.count; index++) {
            
            NSString * jidOld = [self.oldContacts[index] valueForKey:@"jid"];
            
            if ([self equalJid:jidOld And:[contact valueForKey:@"jid"]]) {
                [self.deleteContacts addObject:[NSNumber numberWithInt:index]];
                break;
            }
        }
    }
}

@end
