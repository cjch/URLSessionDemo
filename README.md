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
NSUrl *url = [NSUrl urlWithString:@"www.example.com"];
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

