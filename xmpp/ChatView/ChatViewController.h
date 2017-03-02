//
//  ChatViewController.h
//  xmpp
//
//  Created by Estefania Guardado on 08/11/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"

#import "XMPPFramework.h"
#import "ChatBusinessController.h"
#import "IChatRepresentationHandler.h"

@interface ChatViewController : SLKTextViewController <IChatRepresentationHandler>

@property (strong) ChatBusinessController * chatBusinessController;
@property (strong) NSDictionary * dataRoster;
@property (strong) NSMutableArray * messagesReceived;

@end
