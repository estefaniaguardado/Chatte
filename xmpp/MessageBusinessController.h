//
//  MessageBusinessController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "IMessageDelegate.h"
#import "IMessageDatasource.h"

@interface MessageBusinessController : NSObject <IMessageDelegate, IMessageDatasource>

@property (weak) AppDelegate *appDelegate;

@property (nonatomic, strong) NSMutableArray * roster;

@property (nonatomic, strong) XMPPMessage * message;

@property (nonatomic, assign) BOOL isNewBadge;

@end
