//
//  MessageBusinessController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MessageBusinessController.h"
#import "XMPPFramework.h"

@implementation MessageBusinessController

- (instancetype)init{
    if (self = [super init]) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.appDelegate.infoMessage = self;
    }
    
    return self;
}

- (void) getContactRoster: (NSArray*) roster{
    self.roster = [NSMutableArray arrayWithArray:roster];
}

-(void)handler:(XMPPMessage *)message{
    if ([message isChatMessageWithBody]){
        self.message = message;
        [self updateBadgesInRoster];
    }
}

- (void) updateBadgesInRoster{
    NSString * fromUser = [NSString stringWithFormat:@"%@", [self.message.from bareJID]];

    NSMutableArray * updateRoster = [NSMutableArray arrayWithArray:self.roster];
    [self.roster removeAllObjects];
    [updateRoster enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[contact valueForKey:@"jid"] isEqualToString:fromUser]) {
            int badge = 1;
            if ([contact valueForKey:@"badge"]) {
                badge = badge + [[contact valueForKey:@"badge"] intValue];
            }
            NSDictionary * updateContact = @{
                                             @"jid": [contact valueForKey:@"jid"],
                                             @"name": [contact valueForKey:@"name"],
                                             @"badge": [NSNumber numberWithInt:badge]
                                             };
            [updateRoster replaceObjectAtIndex:idx withObject:updateContact];
            self.idxContact = [NSNumber numberWithInteger:idx];
        }
    }];
    
    [self.roster addObjectsFromArray:updateRoster];
    self.isNewBadge = YES;
}

- (NSArray*) rosterWithUpdatedBadges{
    return [NSArray arrayWithArray:self.roster];
}

- (NSNumber *) getIdxContactOfNewBadge{
    return self.idxContact;
}

@end
