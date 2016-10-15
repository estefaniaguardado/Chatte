//
//  ViewController.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DAOUser.h"

@interface ViewController : UIViewController

@property (weak) AppDelegate *appDelegate;
@property (strong) DAOUser *daoUser;

@property (weak, nonatomic) IBOutlet UITextField *logTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

- (IBAction)login:(id)sender;

@end

