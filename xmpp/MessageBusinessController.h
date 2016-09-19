//
//  MessageBusinessController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/15/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMessageDelegate.h"
#import "IMessageDatasource.h"

@interface MessageBusinessController : NSObject <IMessageDelegate, IMessageDatasource>

@property (nonatomic, strong) NSMutableArray * contactRoster;

@end
