//
//  MessageTableViewCell.h
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic, weak) NSDictionary * data;

@property (weak, nonatomic) IBOutlet UILabel *bodyMessage;

@end
