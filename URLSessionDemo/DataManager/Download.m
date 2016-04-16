//
//  Download.m
//  URLSessionDemo
//
//  Created by chenjie on 16/4/16.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "Download.h"

@implementation Download

+ (instancetype)downloadWithUrl:(NSString *)url {
    Download *download = [[Download alloc] init];
    download.url = url;
    return download;
}

@end
