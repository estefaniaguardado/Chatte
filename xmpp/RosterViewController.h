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
#import "IQuery.h"

@interface RosterViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, IQuery>

@property (strong) NSArray *viewModel;
@property (strong) NSMutableArray * contactRoster;

@property (weak) AppDelegate *appDelegate;
@property (strong) MessageBusinessController * messageBusinessController;

@end
