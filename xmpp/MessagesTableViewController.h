//
//  MessagesTableViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "AppDelegate.h"
#import "IMessage.h"

@interface MessagesTableViewController : UITableViewController
<UITableViewDelegate, UITableViewDataSource, ChatDelegate, IMessage>

@property (weak) AppDelegate *appDelegate;

@property (strong) NSMutableArray * messagesArray;
@property (strong) NSArray *viewModel;
@property (strong) NSMutableSet * messagesRegistered;

@end
