//
//  IMessageDatasource.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@protocol IMessageDatasource <NSObject>

@optional

- (NSMutableArray *) updateBadgesIn: (NSArray *) roster;

@end
