//
//  MessagesTableViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "ConnectionXMPPBusinessController.h"
#import "IMessageDelegate.h"

@interface MessagesTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, IMessageDelegate>

@property (weak) ConnectionXMPPBusinessController *connectionXMPPBusinessController;

@property (strong) NSMutableArray * messagesArray;
@property (strong) NSArray *viewModel;
@property (strong) NSMutableSet * messagesRegistered;

@end
