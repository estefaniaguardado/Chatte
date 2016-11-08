//
//  ChatTableViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ChatTableViewController.h"

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.dataRoster valueForKey:@"name"];
    [self.chatBusinessController setJid:[self.dataRoster valueForKey:@"jid"]];
    [self.chatBusinessController setHandler: self];
    
    self.viewModel = [NSArray array];
    self.messagesArray = [NSMutableArray array];
    self.messagesRegistered = [NSMutableSet set];
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray * messages = [self.chatBusinessController getMessages];
    [self.messagesArray addObjectsFromArray: messages];
    [self updateViewModel];
}

- (void) from: (NSArray *) messages added: (NSDictionary *) message {
    // TODO: Update view model and refresh table
    NSLog(@"Added new message: %@", message);
    [self.messagesArray addObject:message];
    [self updateViewModel];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.messagesArray enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary dictionaryWithDictionary:message];
        
        [viewModel addObject:@{
                               @"nib" : @"MessageTableViewCell",
                               @"height" : @(50),
                               @"data":cellModel }];
    }];
    
    self.viewModel = [NSArray arrayWithArray:viewModel];
    
    [self registerNibs];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

- (void) registerNibs{
    __weak UITableView * tableView = self.tableView;
    NSMutableSet * registeredNibs = [NSMutableSet set];
    
    [self.viewModel enumerateObjectsUsingBlock:^(NSDictionary * cellViewModel, NSUInteger idx, BOOL * stop) {
        
        NSString * nibFile = cellViewModel[@"nib"];
        
        if(![registeredNibs containsObject: nibFile]) {
            [registeredNibs addObject: nibFile];
            
            UINib * nib = [UINib nibWithNibName:nibFile bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nibFile];
        }
    }];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.onlineBuddies.count;
    return [self.viewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    //cell.textLabel.text = [self.onlineBuddies[indexPath.row] string];
    
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: cellViewModel[@"nib"]];
    
    if([cell respondsToSelector:@selector(setData:)]) {
        [cell performSelector:@selector(setData:) withObject:cellViewModel[@"data"]];
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * cellViewModel = self.viewModel[indexPath.row];
    return [cellViewModel[@"height"] floatValue];
}

@end
