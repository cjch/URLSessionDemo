//
//  TrackCell.h
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackEntity.h"

@class TrackCell;

@protocol TrackCellDelegate <NSObject>

- (void)trackCellDownload:(TrackCell *)cell;

@end

@interface TrackCell : UITableViewCell

@property (nonatomic, weak) id<TrackCellDelegate> delegate;
@property (nonatomic, strong) TrackEntity *entity;

@end
