//
//  RosterViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/1/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "RosterViewController.h"

@implementation RosterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.appDelegate.delegate = self;
    
    self.onlineBuddies = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *jabberID = [defaults objectForKey:@"userID"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] != nil) {
        if ([self.appDelegate connect]) {
            self.title = [[[self.appDelegate xmppStream] myJID] bare];
            [[self.appDelegate xmppRoster] fetchRoster];
        }
    } else {
        [self performSegueWithIdentifier:@"Home.To.Login" sender:self];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [self.onlineBuddies[indexPath.row] string];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.onlineBuddies.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alertController = [UIAlertController
                                            alertControllerWithTitle:@"Warning!"
                                            message:@"It will send Yo! to the recipient, continue ?"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action){
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 NSString * message = @"Yo!";
                                 XMPPJID * senderJID = [XMPPJID jidWithString:
                                                        [self.onlineBuddies[indexPath.row] string]];
                                 XMPPMessage* xmppMessage = [[XMPPMessage new] initWithType:@"chat" to:senderJID];
                                 [xmppMessage addBody:message];
                                 [[self.appDelegate xmppStream] sendElement:xmppMessage];
                             }];
    
    [alertController addAction:cancel];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)buddyWentOnline:(NSString *)name{
    if (![self.onlineBuddies containsObject:name]) {
        [self.onlineBuddies addObject:name];
        [self.tableView reloadData];
    }
}

- (void)buddyWentOffline:(NSString *)name{
    [self.onlineBuddies removeObject:name];
    [self.tableView reloadData];
}

- (void)didDisconnect{
    [self.onlineBuddies removeAllObjects];
    [self.tableView reloadData];
}

@end
