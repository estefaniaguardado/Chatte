//
//  ViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "RosterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.logTextField.text = @"yourLogin@gmail.com";
    self.passTextField.text = @"yourPassword";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.logTextField.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passTextField.text forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([appDelegate connect]) {
        [self performSegueWithIdentifier:@"rosterVC" sender:self];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] != nil) {
        if ([self.appDelegate connect]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
