//
//  TrackCell.m
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "TrackCell.h"

@interface TrackCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *atristLabel;

@end

@implementation TrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setEntity:(TrackEntity *)entity {
    _entity = entity;
    self.titleLabel.text = entity.trackName;
    self.atristLabel.text = entity.artistName;
}

@end
