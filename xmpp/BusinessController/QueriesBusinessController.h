//
//  QueriesBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 04/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IQueryDelegate.h"
#import "IQueryDataSource.h"
#import "XMPPBusinessController.h"
#import "RosterBusinessController.h"

@interface QueriesBusinessController : NSObject <IQueryDelegate, IQueryDataSource>

@property (weak) XMPPBusinessController * xmppBusinessController;
@property (strong) RosterBusinessController * rosterBusinessController;

@property (strong) NSMutableArray * contactRoster;

@property (nonatomic, assign) BOOL didReceivedIQRoster;

@end
