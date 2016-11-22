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

@interface ContactBusinessController : NSObject

@property (strong, atomic) NSArray * contacts;
@property (weak) id<IContactRepresentationHandler> handler;
@property (weak) id<IDAOContact> daoContact;

@end
