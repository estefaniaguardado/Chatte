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
    
    NSMutableSet * oldSetData = [NSMutableSet setWithArray:oldContacts];
    NSMutableSet * newSetData = [NSMutableSet setWithArray:newContacts];
    
    [oldSetData minusSet:newSetData];
    [newSetData minusSet:[NSMutableSet setWithArray:oldContacts]];
    
    self.addNewContacts = [NSMutableArray array];
    self.deleteContacts = [NSMutableArray array];
    self.updateContacts = [NSMutableArray array];
    
    if ([oldSetData count] && [newSetData count]) {
        [self compare:oldContacts WithSetContacts:oldSetData And:newSetData];
        
    } else {
        [self compare:oldContacts With:newSetData];
        
        NSMutableSet * copyOldContacts = [NSMutableSet setWithArray:oldContacts];
        if ([oldSetData count] && ![copyOldContacts isEqualToSet:oldSetData]) {
            [self compareOldData:oldContacts With:oldSetData];
        }
    }
}

- (void) compare: (NSArray*)oldContacts With:(NSSet *) newSetData{
    for (int index = 1; index <= newSetData.count; index++){
        NSNumber * number = [NSNumber numberWithInt:(int)oldContacts.count + index];
        [self.addNewContacts addObject:number];
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

- (void) compare: (NSArray*)oldData WithSetContacts: (NSSet*) oldContacts And: (NSSet*) newContacts{
    NSMutableSet * copyOldContacts = [NSMutableSet setWithSet:oldContacts];
    NSMutableSet * copyNewContacts = [NSMutableSet setWithSet:newContacts];
    
    for (NSDictionary *oldContact in oldContacts) {
        for (NSDictionary * newContact in newContacts) {
            
            if ([self equalJid:[oldContact valueForKey:@"jid"] And:[newContact valueForKey:@"jid"]]) {
                
                for (int index = 0; index < oldData.count; index++) {
                    NSString * jidOld = [oldData[index] valueForKey:@"jid"];
                    
                    if ([self equalJid:jidOld And:[newContact valueForKey:@"jid"]]) {
                        NSNumber * number = [NSNumber numberWithInt:index];
                        [self.updateContacts addObject:number];
                        [copyOldContacts minusSet:[NSSet setWithObject:oldContact]];
                        [copyNewContacts minusSet:[NSSet setWithObject:newContact]];
                        break;
                    }
                }
            }
        }
        if (![copyOldContacts count] || ![copyNewContacts count]) {
            break;
        }
    }
    
    [self compareOldData:oldData With:copyOldContacts];
    [self compare:oldData With:copyNewContacts];
}

- (BOOL) equalJid: (NSString*)firstJid And: (NSString*) secondJid{
    return [firstJid isEqualToString:secondJid];
}

- (void) compareOldData:(NSArray*)oldData With: (NSSet*) oldSetData{
    
    for (NSDictionary * contact in oldSetData){
        for (int index = 0; index < oldData.count; index++) {
            
            NSString * jidOld = [oldData[index] valueForKey:@"jid"];
            
            if ([self equalJid:jidOld And:[contact valueForKey:@"jid"]]) {
                [self.deleteContacts addObject:[NSNumber numberWithInt:index]];
                break;
            }
        }
    }
}

@end
