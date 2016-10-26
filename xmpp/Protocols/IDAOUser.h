//
//  IDAOUser.h
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDAOUser <NSObject>

- (void)updateValues: (NSDictionary*) user;
- (NSDictionary *) getUser;
    
@end
