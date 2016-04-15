//
//  TrackEntity.h
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TrackEntity <NSObject>
@end

@interface TrackEntity : JSONModel

@property (nonatomic, copy) NSString *kind;
@property (nonatomic, assign) int trackId;
@property (nonatomic, assign) int artistId;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *trackName;

@property (nonatomic, copy) NSString *previewUrl;

@end

@interface TrackResultsEntity : JSONModel

@property (nonatomic, assign) int resultCount;
@property (nonatomic, strong) NSArray<TrackEntity> *results;

@end
