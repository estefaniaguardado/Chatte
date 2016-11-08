//
//  IChatRepresentationHandler.h
//  xmpp
//
//  Created by Estefania Guardado on 05/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IChatRepresentationHandler <NSObject>

- (void) from: (NSArray *) messages added: (NSDictionary *) message;

@end
