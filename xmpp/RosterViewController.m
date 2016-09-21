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
    self.appDelegate.resultIQ = self;
    
    self.messageBusinessController = [[MessageBusinessController alloc] init];
    
    self.contactRoster = [NSMutableArray array];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self getRoster];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.title = [[[self.appDelegate xmppStream] myJID] bare];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"%@", [self.messageBusinessController didReceivedMessage]);
}

- (void)didReceiveIQ:(XMPPIQ *)iq{

    NSXMLElement * query = [iq elementForName:@"query"];
    NSArray *items = [query elementsForName:@"item"];
    
    for (NSXMLElement * value in items) {
        NSDictionary * contact = @{
                                   @"name" : [value attributeStringValueForName:@"name"],
                                   @"jid" : [value attributeStringValueForName:@"jid"]
                                   };
        //XMPPJID *jid = [XMPPJID jidWithString:jidString];
        [self.contactRoster addObject:contact];
    }
    
    [self updateViewModel];
}

- (void) getRoster {
    
    NSXMLElement *xmlns = [NSXMLElement elementWithName:@"query"];
    [xmlns addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    [xmlns addAttributeWithName:@"xmlns:gr" stringValue:@"google:roster"];
    [xmlns addAttributeWithName:@"gr:ext" stringValue:@"2"];
    
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"from" stringValue:[[[self.appDelegate xmppStream] myJID] full]];
    [iq addAttributeWithName:@"id" stringValue:@"v1"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:xmlns];
    
    [[self.appDelegate xmppStream] sendElement:iq];
}

- (void) updateViewModel {
    NSMutableArray * viewModel = [NSMutableArray array];
    [self.contactRoster enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * stop) {
        
        NSMutableDictionary * cellModel = [NSMutableDictionary
                                           dictionaryWithDictionary:contact];
        
        [viewModel addObject:@{
                               @"nib" : @"ContactTableViewCell",
                               @"height" : @(70),
                               @"data":cellModel }];
    }];
    
    self.viewModel = [NSArray arrayWithArray:viewModel];
    
    [self registerNibs];
    
    [self.tableView reloadData];
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
    
    return [self update:cell];
}

- (UITableViewCell *) update: (UITableViewCell *) cell{
    int number = 2;
    static CGFloat size = 26;
    static CGFloat digits = 1;
    UILabel * accesoryBadge = [UILabel new];
    accesoryBadge.text = [NSString stringWithFormat:@"%i", number];
    accesoryBadge.backgroundColor = [UIColor blueColor];
    accesoryBadge.textColor = [UIColor whiteColor];
    accesoryBadge.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    accesoryBadge.textAlignment = NSTextAlignmentCenter;
    accesoryBadge.layer.cornerRadius = 13;
    accesoryBadge.layer.masksToBounds = true;
    
    accesoryBadge.frame = CGRectMake(0, 0, fmax(size, 0.7 * size * digits), size);
    cell.accessoryView = accesoryBadge;
    
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
