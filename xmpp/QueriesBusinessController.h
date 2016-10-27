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
#import "ConnectionXMPPBusinessController.h"
#import "MessageBusinessController.h"

@interface QueriesBusinessController : NSObject <IQueryDelegate, IQueryDataSource>

@property (weak) ConnectionXMPPBusinessController * connectionXMPPBusinessController;
@property (strong) MessageBusinessController * messageBusinessController;

@property (strong) NSMutableArray * contactRoster;

@property (nonatomic, assign) BOOL didReceivedIQRoster;

@end
