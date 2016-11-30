//
//  RosterViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "XMPPFramework.h"

#import "XMPPBusinessController.h"
#import "RosterBusinessController.h"
#import "ContactBusinessController.h"

#import "Protocols/IDAOUser.h"
#import "Protocols/IDAOContact.h"
#import "Protocols/IContactRepresentationHandler.h"

@interface RosterViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource,
DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,
IContactRepresentationHandler>

@property (strong) NSArray *viewModel;
@property (strong) NSMutableArray * contactRoster;
@property (nonatomic, assign) BOOL updatedBagesInRoster;

@property (strong) NSMutableArray * indexPathAdd;
@property (strong) NSMutableArray * indexPathDelete;
@property (strong) NSMutableArray * indexPathUpdate;

@property (weak) id<IDAOUser> daoUser;
@property (weak) id<IDAOContact> daoContact;

@property (weak) XMPPBusinessController *xmppBusinessController;
@property (strong) ContactBusinessController * contactBusinessController;
@property (strong) RosterBusinessController * rosterBusinessController;

@end
