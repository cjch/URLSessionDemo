//
//  DataRequestManager.m
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "DataRequestManager.h"
#import "TrackEntity.h"
#import <UIKit/UIkit.h>
#import "Download.h"

@interface DataRequestManager () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *downloadSession;
@property (nonatomic, strong) NSURLSession *defaultSession;
@property (nonatomic, strong) NSURLSessionDataTask *searchTask;

@property (nonatomic, strong) NSMutableDictionary *activeDownloads;

@end

@implementation DataRequestManager

+ (instancetype)getInstance {
    DataRequestManager *manager = [DataRequestManager new];
    manager.defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    return manager;
}

- (void)search:(NSString *)searchText callBack:(DataCallBack)callback {
    if (!self.searchTask) {
        [self.searchTask cancel];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *searchTerm = [searchText stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/search?media=music&entity=song&term=%@", searchTerm]];
    
    self.searchTask = [self.defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSError *jError;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jError];
        if (!error && jsonObject) {
            NSError *dError;
            TrackResultsEntity *results = [[TrackResultsEntity alloc] initWithDictionary:jsonObject error:&dError];
            if (results) {
                callback(results, YES);
            } else {
                callback(nil, NO);
            }
        } else {
            callback(nil, NO);
        }
    }];
    
    [self.searchTask resume];
}

#pragma mark - TrackCellDelegate
- (void)trackCellDownload:(TrackCell *)cell {
    NSString *urlStr = cell.entity.previewUrl;
    NSURL *url = [NSURL URLWithString:urlStr];
    Download *download = [Download downloadWithUrl:urlStr];
    download.downloadTask = [self.downloadSession downloadTaskWithURL:url];
    [download.downloadTask resume];
    download.isDownloading = YES;
    self.activeDownloads[urlStr] = download;
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSURL *url = downloadTask.originalRequest.URL;
    NSURL *destPath = [self localFilePathForUrl:url];
    NSLog(@"dest: %@", destPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    @try {
        [fm removeItemAtURL:destPath error:nil];
    } @catch (NSException *exception) {
        NSLog(@"remove path error");
    }
    
    @try {
        [fm copyItemAtURL:location toURL:destPath error:nil];
    } @catch (NSException *exception) {
        NSLog(@"copy file error");
    }
    self.activeDownloads[url.absoluteString] = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSURL *url = downloadTask.originalRequest.URL;
    Download *download = self.activeDownloads[url.absoluteString];
    if (download) {
        download.progress = bytesWritten / (float)totalBytesExpectedToWrite;
        download.totalSize = totalBytesExpectedToWrite;
    }
}

#pragma mark - helper
- (NSURL *)localFilePathForUrl:(NSURL *)url {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSString *lastComponent = url.lastPathComponent;
    NSString *localPath = [documentPath stringByAppendingPathComponent:lastComponent];
    return [NSURL URLWithString:localPath];
}

#pragma mark - getter
- (NSMutableDictionary *)activeDownloads {
    if (!_activeDownloads) {
        _activeDownloads = [[NSMutableDictionary alloc] init];
    }
    return _activeDownloads;
}

- (NSURLSession *)downloadSession {
    if (!_downloadSession) {
        _downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _downloadSession;
}

@end
