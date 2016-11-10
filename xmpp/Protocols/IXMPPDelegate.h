//
//  IXMPPDelegate.h
//  xmpp
//
//  Created by Estefania Guardado on 10/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IXMPPDelegate <NSObject>

- (void) sendMessage:(NSString *) bodyMessage to: (NSString *) receiver;

@end
