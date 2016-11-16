//
//  DAOContactsRLM.h
//  xmpp
//
//  Created by Estefania Guardado on 16/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactRLM.h"
#import "../Protocols/IDAOContact.h"

@interface DAOContactsRLM : NSObject <IDAOContact>

@property (strong) RLMRealm * realm;

@end
