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

#import "../Protocols/IDAOContact.h"

@interface QueriesBusinessController : NSObject <IQueryDelegate, IQueryDataSource>

@property (weak) id<IDAOContact> daoContact;

@property (weak) XMPPBusinessController * xmppBusinessController;
@property (strong) RosterBusinessController * rosterBusinessController;

@property (strong) NSMutableArray * contactRoster;

@end
