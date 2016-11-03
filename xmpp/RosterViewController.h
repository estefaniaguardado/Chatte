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
#import "QueriesBusinessController.h"

#import "Protocols/IDAOUser.h"

@interface RosterViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (strong) NSArray *viewModel;
@property (strong) NSMutableArray * contactRoster;
@property (nonatomic, assign) BOOL updatedBagesInRoster;

@property (weak) id<IDAOUser> daoUser;

@property (weak) XMPPBusinessController *xmppBusinessController;
@property (strong) RosterBusinessController * rosterBusinessController;
@property (strong) QueriesBusinessController * queriesBusinessController;

@end
