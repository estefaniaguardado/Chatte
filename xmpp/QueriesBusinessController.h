//
//  QueriesBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 04/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "IQueryDelegate.h"
#import "IQueryDataSource.h"
#import "MessageBusinessController.h"

@interface QueriesBusinessController : NSObject <IQueryDelegate, IQueryDataSource>

@property (weak) AppDelegate *appDelegate;
@property (strong) MessageBusinessController * messageBusinessController;

@property (strong) NSMutableArray * contactRoster;

@property (nonatomic, assign) BOOL didReceivedIQRoster;

@end
