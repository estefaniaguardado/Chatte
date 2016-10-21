//
//  UserBusinessController.h
//  xmpp
//
//  Created by Estefania Guardado on 21/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAOUserDefaults.h"
#import "IUserDatasource.h"
#import "IUserDelegate.h"

@interface UserBusinessController : NSObject <IUserDatasource,IUserDelegate>

@property (strong) DAOUserDefaults *daoUserDefaults;

@end
