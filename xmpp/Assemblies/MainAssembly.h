//
//  MainAssembly.h
//  xmpp
//
//  Created by Estefania Guardado on 26/10/2016.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <Typhoon/Typhoon.h>

#import "XMPPFramework.h"

@class AppDelegate;

@interface MainAssembly : TyphoonAssembly
    
-(AppDelegate *) appDelegate;

@end
