//
//  UpdateValuesHandler.h
//  xmpp
//
//  Created by Estefania Guardado on 25/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContactRepresentationHandler.h"

@interface UpdateValuesHandler : NSObject <IContactRepresentationHandler>

@property (weak) NSArray * oldContacts;
@property (weak) NSArray * recentContacts;

@property (weak) NSMutableArray * updateContacts;
@property (weak) NSMutableArray * deleteContacts;
@property (weak) NSMutableArray * addNewContacts;

- (NSArray *) getContactsForDelete;
- (NSArray *) getContactsForAdd;
- (NSArray *) getContactsForRefresh;

@end
