//
//  User.m
//  xmpp
//
//  Created by Estefania Guardado on 13/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "User.h"

@implementation User
    
    + (NSString *)primaryKey
    {
        return @"id";
    }
    
+ (NSDictionary *)defaultPropertyValues
    {
        return @{
                 @"name"              : @"",
                 @"email"             : @"",
                 };
    }
    
- (NSMutableDictionary *)toDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if([self email])
    dictionary[@"email"] = [self email];
    if([self name])
    dictionary[@"name"] = [self name];
    if([self jid])
    dictionary[@"jid"] = [self jid];
    if ([self xmppContact])
    dictionary[@"xmppContact"] = @([self xmppContact]);
    
    return dictionary;
}
    
- (id)copy {
    User *copy = [User new];
    copy.name = self.name;
    copy.email = self.email;
    copy.xmppContact = self.xmppContact;
    return copy;
}
    
//- (NSString *)jid {
//    return [NSString stringWithFormat:@"%@@%@", self.id, XMPPDomain];
//}
    
@end
