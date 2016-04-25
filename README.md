# URLSessionDemo

##NSURLSession
###type (NSURLSessionConfiguration)
- default
- ephemeral
- background

###task type (NSURLSessionTask)
- data (NSURLSessionDataTask)
- upload (NSURLSessionUploadTask)
- download (NSURLSessionDownloadTask)

###action response
- block: system delegate
- delegate: custom delgate


```objective-c
NSURL *url = [NSURL urlWithString:@"www.example.com"];
NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

//using system delegate
NSURLSession *session = [NSURLSession sesstionWithConfiguration:config];
NSURLSessionDataTask *task = [session dataTaskWithUrl:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
	//body
}];
[task resume];

//using custom delgate
NSURLSession *session = [NSURLSession sesstionWithConfiguration:config delegate:self delegateQueue:nil];
NSURLSessionDataTask *task = [session dataTaskWithUrl:url];
[task resume];

# pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler { 
	//body
}

```

###Background Session
用户强制关闭程序，后台session会断掉。程序运行在后台时，

```objective-c
/// session delegate file
// implement protocol(NSURLSessionDelegate) method
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    void (^completeHandler)() = [AppDelegate getInstance].bgCompleteHandlerDict[session.configuration.identifier];
    [AppDelegate getInstance].bgCompleteHandlerDict[session.configuration.identifier] = nil;
    if (completeHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"call complete handler");
            completeHandler();
        });
    }
}

// background session initialize
NSURLSession *bgSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"bgSession"] delegate:self delegateQueue:nil];


/// AppDelegate.h
@property (nonatomic, strong) NSMutableDictionary *bgCompleteHandlerDict;
+ (instancetype)getInstance;

/// AppDelegate.m
// implement protocol(UIApplicationDelegate) method
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    if (!self.bgCompleteHandlerDict) {
        self.bgCompleteHandlerDict = [NSMutableDictionary dictionary];
    }
    NSLog(@"Complete BackgroundURLSession's identifier: %@", identifier);
    if (self.bgCompleteHandlerDict[identifier]) {
        NSLog(@"Got multiple handlers for a single session identifier.  This should not happen. ");
    }
    self.bgCompleteHandlerDict[identifier] = completionHandler;
}

```

##Reference

[URL Session Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/Articles/UsingNSURLSession.html#//apple_ref/doc/uid/TP40013509-SW1)
