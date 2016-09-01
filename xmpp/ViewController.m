//
//  ViewController.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

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
    [[NSUserDefaults standardUserDefaults] setObject:self.logTextField.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passTextField.text forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([appDelegate connect]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
