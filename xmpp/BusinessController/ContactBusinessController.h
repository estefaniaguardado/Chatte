//
//  ContactBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 22/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPBusinessController.h"
#import "../protocols/IContactRepresentationHandler.h"
#import "../protocols/IDAOContact.h"

#import "../Utilities/UpdateValuesHandler.h"

@interface ContactBusinessController : NSObject

@property (weak) id<IContactRepresentationHandler> handler;
@property (weak) id<IDAOContact> daoContact;
@property (weak) UpdateValuesHandler * updateValuesHandler;

@end
