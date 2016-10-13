//
//  User.h
//  xmpp
//
//  Created by Estefania Guardado on 13/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface User : RLMObject
    
    @property NSString *name;
    @property NSString *email;
    
    @property bool     xmppContact;

    @property (readonly) NSString *jid;
    
@end

RLM_ARRAY_TYPE(User)
