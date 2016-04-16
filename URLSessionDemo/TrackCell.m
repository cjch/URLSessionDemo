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
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation TrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.downloadButton addTarget:self action:@selector(onDownload) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEntity:(TrackEntity *)entity {
    _entity = entity;
    self.titleLabel.text = entity.trackName;
    self.atristLabel.text = entity.artistName;
}


- (void)onDownload {
    if (self.delegate && [self.delegate respondsToSelector:@selector(trackCellDownload:)]) {
        [self.delegate trackCellDownload:self];
    }
}

@end
