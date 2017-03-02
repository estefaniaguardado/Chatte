//
//  ContactRLM.h
//  xmpp
//
//  Created by Estefania Guardado on 16/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Realm/Realm.h>

@interface ContactRLM : RLMObject

@property NSString *jid;
@property NSString *name;

@end
RLM_ARRAY_TYPE(Contact)
