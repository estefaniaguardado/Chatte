//
//  MessageBusinessController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MessageBusinessController.h"
#import "XMPPFramework.h"

@interface MessageBusinessController ()

@property (nonatomic, strong) XMPPMessage * message;

@end

@implementation MessageBusinessController


- (instancetype)init{
    if (self = [super init]) {
        self.message = [XMPPMessage alloc];
    }
    
    return self;
}

- (NSMutableArray *)updateBadgesIn:(NSArray *)roster{
    NSString * fromUser = [NSString stringWithFormat:@"%@", self.message.from];

    NSMutableArray * updateRoster = [NSMutableArray arrayWithArray:roster];
    [roster enumerateObjectsUsingBlock:^(NSDictionary * contact, NSUInteger idx, BOOL * _Nonnull stop) {
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
        }
    }];
    
    return updateRoster;
}

- (void) getRequested:(XMPPMessage *)message{
    self.message = message;
}

@end
