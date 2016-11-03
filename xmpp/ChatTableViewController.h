//
//  ChatTableViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "ChatBusinessController.h"
#import "IRosterDelegate.h"

@interface ChatTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, IRosterDelegate>

@property (strong) ChatBusinessController * chatBusinessController;

@property (strong) NSMutableArray * messagesArray;
@property (strong) NSArray *viewModel;
@property (strong) NSMutableSet * messagesRegistered;
@property (strong) NSDictionary * dataRoster;


@end
