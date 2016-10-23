//
//  UserBusinessController.m
//  xmpp
//
//  Created by Estefania Guardado on 21/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "UserBusinessController.h"

@implementation UserBusinessController

- (instancetype)init{
    if (self = [super init]) {
        self.daoUserDefaults = [[DAOUserDefaults alloc] init];
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.appDelegate.infoUser = self;
    }
    
    return self;
}

- (void) updateInformation: (NSDictionary*) user{
    [self.daoUserDefaults updateValues:user];
}

- (NSDictionary *) getInformationUser{
    return [self.daoUserDefaults getUser];
}

@end
