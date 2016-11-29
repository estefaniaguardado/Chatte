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

-(NSDictionary*) calculateArrayIndexOfContacts:(NSArray*)oldContacts And:(NSArray*)newContacts{
    
    NSMutableSet * oldSetData = [NSMutableSet setWithArray:oldContacts];
    NSMutableSet * newSetData = [NSMutableSet setWithArray:newContacts];
    
    [oldSetData minusSet:newSetData];
    [newSetData minusSet:[NSMutableSet setWithArray:oldContacts]];
    
    if ([oldSetData count] && [newSetData count]) {
        return [self compare:oldContacts WithSetContacts:oldSetData And:newSetData];
        
    } else {
        NSArray * addNewContacts = [NSArray arrayWithArray:[self compare:oldContacts With:newSetData]];
        
        NSMutableArray * deleteContacts = [NSMutableArray array];
        NSMutableSet * copyOldContacts = [NSMutableSet setWithArray:oldContacts];
        if ([oldSetData count] && ![copyOldContacts isEqualToSet:oldSetData]) {
            deleteContacts = [NSMutableArray arrayWithArray:[self compareOldData:oldContacts With:oldSetData]];
        }
        
        return @{
                 @"add": addNewContacts,
                 @"delete": deleteContacts,
                 @"update": @[]
                 };
    }
}

- (NSArray*) compare: (NSArray*)oldContacts With:(NSSet *) newSetData{
    NSMutableArray * addNewContacts = [NSMutableArray array];
    
    for (int index = 1; index <= newSetData.count; index++){
        NSNumber * number = [NSNumber numberWithInt:(int)oldContacts.count + index];
        [addNewContacts addObject:number];
    }
    
    return addNewContacts;
}

- (NSDictionary*) compare: (NSArray*)oldData WithSetContacts: (NSSet*) oldContacts And: (NSSet*) newContacts{
    NSMutableSet * copyOldContacts = [NSMutableSet setWithSet:oldContacts];
    NSMutableSet * copyNewContacts = [NSMutableSet setWithSet:newContacts];
    NSMutableArray *updateContacts = [NSMutableArray array];
    
    for (NSDictionary *oldContact in oldContacts) {
        for (NSDictionary * newContact in newContacts) {
            
            if ([self equalJid:[oldContact valueForKey:@"jid"] And:[newContact valueForKey:@"jid"]]) {
                
                for (int index = 0; index < oldData.count; index++) {
                    NSString * jidOld = [oldData[index] valueForKey:@"jid"];
                    
                    if ([self equalJid:jidOld And:[newContact valueForKey:@"jid"]]) {
                        NSNumber * number = [NSNumber numberWithInt:index];
                        [updateContacts addObject:number];
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
    
    return @{
             @"add": [self compare:oldData With:copyNewContacts],
             @"delete": [self compareOldData:oldData With:copyOldContacts],
             @"update": updateContacts
             };
}

- (BOOL) equalJid: (NSString*)firstJid And: (NSString*) secondJid{
    return [firstJid isEqualToString:secondJid];
}

- (NSArray*) compareOldData:(NSArray*)oldData With: (NSSet*) oldSetData{
    NSMutableArray * deleteContacts = [NSMutableArray array];
    
    for (NSDictionary * contact in oldSetData){
        for (int index = 0; index < oldData.count; index++) {
            
            NSString * jidOld = [oldData[index] valueForKey:@"jid"];
            
            if ([self equalJid:jidOld And:[contact valueForKey:@"jid"]]) {
                [deleteContacts addObject:[NSNumber numberWithInt:index]];
                break;
            }
        }
    }
    
    return deleteContacts;
}

@end
