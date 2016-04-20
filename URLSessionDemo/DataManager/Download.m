//
//  Download.m
//  URLSessionDemo
//
//  Created by chenjie on 16/4/16.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "Download.h"
#import "TrackCell.h"

@implementation Download

+ (instancetype)downloadWithUrl:(NSString *)url {
    Download *download = [[Download alloc] init];
    download.url = url;
    return download;
}

- (void)refreshCell {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cell setDownload:self];
    });
}



@end
