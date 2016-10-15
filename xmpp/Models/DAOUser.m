//
//  DAOUser.m
//  xmpp
//
//  Created by Estefania Guardado on 15/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "DAOUser.h"

@implementation DAOUser

- (void)initValues
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateValues: (NSDictionary*) user
{
    [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"userID"] forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"userPassword"] forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) userID{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}

- (NSString *) userPassword{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
}

@end

