//
//  Header.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@protocol IQueryDelegate <NSObject>

@optional

- (void) handler: (XMPPIQ*) iq;

@end
