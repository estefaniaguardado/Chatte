//
//  ChatBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 02/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ChatBusinessController.h"

@implementation ChatBusinessController

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerMessage:)
                                                 name:@"notificationMessage" object:nil];
    
    return self;
}

- (void) handlerMessage:(NSNotification*) notification{

    NSDictionary * message = notification.userInfo;
    NSString * from = [message valueForKey:@"from"];
    
    if ([self.jid isEqualToString:from]) {
        NSLog(@"a");

    }
}

@end
