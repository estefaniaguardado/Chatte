//
//  UserRLM.h
//  xmpp
//
//  Created by Estefania Guardado on 29/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserRLM : RLMObject

@property NSString *jid;
@property NSString *password;

@end
