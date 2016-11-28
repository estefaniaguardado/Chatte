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
        //[self compareSetContacts:oldSetData And:newSetData];
        
    } else {
        for (int index = 1; index <= newSetData.count; index++){
            //add new contact
            NSNumber * number = [NSNumber numberWithInt:(int)self.oldContacts.count + index];
            [self.addNewContacts addObject:number];
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

//- (void) compareSetContacts: (NSSet*) oldContacts And: (NSSet*) newContacts{
//    NSMutableSet* copyNewContacts = [NSMutableSet setWithSet:newContacts];
//    NSMutableSet* copyOldContacts = [NSMutableSet setWithSet:oldContacts];
//
//
//    for (NSDictionary * oldContact in oldContacts) {
//        for (NSDictionary * newContact in newContacts) {
//            if ([self equalJid:[oldContact valueForKey:@"jid"]
//                           And:[newContact valueForKey:@"jid"]]) {
//                //edit contact with new data
//
//                [copyNewContacts minusSet:[NSSet setWithObject:newContact]];
//                [copyOldContacts minusSet:[NSSet setWithObject:oldContact]];
//            }
//        }
//        if (![copyNewContacts count] || ![copyOldContacts count]) {
//            break;
//        }
//    }
//
//    for (NSDictionary * contact in copyNewContacts) {
//        //add new contact
//    }
//    for (NSDictionary * contact in copyOldContacts) {
//        //delete old contact
//    }
//}

- (BOOL) equalJid: (NSString*)firstJid And: (NSString*) secondJid{
    return [firstJid isEqualToString:secondJid];
}

@end
