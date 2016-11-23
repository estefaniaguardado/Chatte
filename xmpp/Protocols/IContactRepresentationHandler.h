//
//  IContactRepresentationHandler.h
//  xmpp
//
//  Created by Estefania Guardado on 22/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IContactRepresentationHandler <NSObject>

- (void) updateValues:(NSArray *) oldDataContact With: (NSArray *) newDataContact;

@end
