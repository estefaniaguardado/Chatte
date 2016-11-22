//
//  ContactBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 22/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ContactBusinessController.h"

@implementation ContactBusinessController

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlerIQ:)
                                                 name:@"IQroster" object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void) handlerIQ:(NSNotification*) notification{
    self.contacts = [self.daoContact getContacts];
    
    NSArray * updateContacts = [[notification userInfo] objectForKey:@"contacts"];
    
    [self.daoContact updateValues:updateContacts];
    
    [self.handler updateValues:self.contacts With:[self.daoContact getContacts]];
}

@end
