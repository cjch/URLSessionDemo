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

@interface DataRequestManager ()

@property (nonatomic, strong) NSURLSession *defaultSession;
@property (nonatomic, strong) NSURLSessionDataTask *searchTask;

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

@end
