//
//  DAOUser.h
//  xmpp
//
//  Created by Estefania Guardado on 15/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAOUserDefaults : NSObject

- (void)updateValues: (NSDictionary*) user;
- (NSDictionary *) getUser;

@end
