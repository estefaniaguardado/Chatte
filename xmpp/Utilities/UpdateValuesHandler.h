//
//  UpdateValuesHandler.h
//  xmpp
//
//  Created by Estefania Guardado on 25/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateValuesHandler : NSObject

@property (strong) NSMutableArray * updateContacts;
@property (strong) NSMutableArray * deleteContacts;
@property (strong) NSMutableArray * addNewContacts;

- (NSArray *) getContactsForDelete;
- (NSArray *) getContactsForAdd;
- (NSArray *) getContactsForRefresh;

-(void) calculateArrayIndexOfContacts:(NSArray*)oldContacts And:(NSArray*)newContacts;

@end
