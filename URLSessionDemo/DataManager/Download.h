//
//  Download.h
//  URLSessionDemo
//
//  Created by chenjie on 16/4/16.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DownloadStatus) {
    DownloadStatusReady = 0,
    DownloadStatusDownloading,
    DownloadStatusPause,
    DownloadStatusFinished
};

@class TrackCell;

@interface Download : NSObject

@property (nonatomic, weak) TrackCell *cell;
@property (nonatomic, assign) DownloadStatus status;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) long totalSize;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

+ (instancetype)downloadWithUrl:(NSString *)url;
- (void)refreshCell;

@end
