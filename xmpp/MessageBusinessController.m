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
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.appDelegate.infoMessage = self;
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

-(void)handler:(XMPPMessage *)message{
    if ([message isChatMessageWithBody]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            self.message = message;
        });
    }
}

@end
