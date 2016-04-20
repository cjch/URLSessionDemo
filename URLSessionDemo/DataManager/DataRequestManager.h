//
//  DataRequestManager.h
//  URLSessionDemo
//
//  Created by jiechen on 16/4/15.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackCell.h"

typedef void (^DataCallBack)(id results, BOOL isSuccess);

@interface DataRequestManager : NSObject <TrackCellDelegate>

+ (instancetype)getInstance;

- (void)search:(NSString *)searchText callBack:(DataCallBack)callback;
- (BOOL)urlIsDownload:(NSString *)url;
- (Download *)downloadWithUrl:(NSString *)url;

@end
