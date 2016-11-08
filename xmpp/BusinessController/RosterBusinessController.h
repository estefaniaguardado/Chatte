//
//  RosterBusinessController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRosterDelegate.h"
#import "IRosterDatasource.h"

@interface RosterBusinessController : NSObject <IRosterDatasource, IRosterDelegate>

@property (nonatomic, strong) NSMutableArray * roster;

@property (nonatomic, strong) XMPPMessage * message;

@property (nonatomic, assign) BOOL isNewBadge;
@property (nonatomic, strong) NSNumber * idxContact;

@end
