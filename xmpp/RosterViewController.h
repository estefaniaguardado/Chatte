//
//  RosterViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "AppDelegate.h"
#import "MessageBusinessController.h"
#import "QueriesBusinessController.h"

@interface RosterViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource>

@property (strong) NSArray *viewModel;
@property (strong) NSMutableArray * contactRoster;
@property (nonatomic, assign) BOOL updatedBagesInRoster;

@property (weak) AppDelegate *appDelegate;
@property (strong) MessageBusinessController * messageBusinessController;
@property (strong) QueriesBusinessController * queriesBusinessController;

@end
