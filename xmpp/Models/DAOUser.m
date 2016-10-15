//
//  DAOUser.m
//  xmpp
//
//  Created by Estefania Guardado on 15/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "DAOUser.h"

@implementation DAOUser

- (void)updateValues: (NSDictionary*) user
{
    [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"userID"] forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"userPassword"] forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *) getUser{
    
    return @{
             
             @"userID" : [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],
             @"userPassword": [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]
             };
}

@end

