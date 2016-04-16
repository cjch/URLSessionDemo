//
//  Download.h
//  URLSessionDemo
//
//  Created by chenjie on 16/4/16.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackCell.h"

@interface Download : NSObject

@property (nonatomic, weak) TrackCell *cell;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) long totalSize;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

+ (instancetype)downloadWithUrl:(NSString *)url;

@end
