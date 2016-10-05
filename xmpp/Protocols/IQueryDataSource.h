//
//  IQueryDataSource.h
//  xmpp
//
//  Created by Estefania Guardado on 04/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@protocol IQueryDataSource <NSObject>

@optional

- (NSMutableArray*) getRoster;
- (void) sendIQToGetRoster;
- (void) formatToReceivedRoster: (XMPPIQ*) iq;

@end
