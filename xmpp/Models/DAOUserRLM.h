//
//  DAOUser.h
//  xmpp
//
//  Created by Estefania Guardado on 29/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserRLM.h"
#import "../Protocols/IDAOUser.h"

@interface DAOUserRLM : NSObject <IDAOUser>

@property (strong) RLMRealm * realm;

@end
