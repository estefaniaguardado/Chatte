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
        self.daoUser = [[DAOUser alloc] init];

    }
    
    return self;
}

- (void) updateInformation: (NSDictionary*) user{
    [self.daoUser updateValues:user];
}

- (NSDictionary *) getInformationUser{
    return [self.daoUser getUser];
}

@end
