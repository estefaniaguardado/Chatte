//
//  ContactTableViewCell.m
//  xmpp
//
//  Created by Estefania Chavez Guardado on 9/9/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

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
    
    [self.nameContact setText: _data[@"name"]];
    NSString * status = [NSString string];
    status = _data[@"status"];
    if (status) {
        if ([status isEqualToString:@"online"]) {
            [self.contactStatus setImage:[UIImage imageNamed:@"online"]];
        } else if ([status isEqualToString:@"away"]) {
            [self.contactStatus setImage:[UIImage imageNamed:@"away"]];
        } else if ([status isEqualToString:@"busy"]) {
            [self.contactStatus setImage:[UIImage imageNamed:@"busy"]];
        } else if ([status isEqualToString:@"offline"]) {
            [self.contactStatus setImage:[UIImage imageNamed:@"offline"]];
        }
    } else{
        [self.contactStatus setImage:[UIImage imageNamed:@"offline"]];
    }
}

@end
