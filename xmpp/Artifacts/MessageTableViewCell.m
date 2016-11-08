//
//  MessageTableViewCell.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/6/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSDictionary *)data {
    _data = data;
    
    [self.bodyMessage setText: _data[@"body"]];
}

@end
