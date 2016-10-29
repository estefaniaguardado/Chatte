//
//  ViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RosterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logTextField.text = @"yourLogin@gmail.com";
    self.passTextField.text = @"yourPassword";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    NSDictionary * infoUser = [NSDictionary
                               dictionaryWithObjectsAndKeys:
                               self.logTextField.text, @"userID",
                               self.passTextField.text, @"userPassword",
                               nil];
    
    if ([self.connectionXMPPBusinessController connectUser:infoUser]) {
        if ([self shouldPerformSegueWithIdentifier:@"rosterVC" sender:self]) {
            [self performSegueWithIdentifier:@"rosterVC" sender:self];
        }
    }
}

/*- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([[self.daoUser getUser] valueForKey:@"userID"] != nil) {
        if ([self.connectionXMPPBusinessController connect]) {
            return YES;
        }
        return NO;
    }
    return NO;
}*/


@end
