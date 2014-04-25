### STHTTPRequest

_A NSURLConnection wrapper for humans_

##### Simple...

-   600 lines of Objective-C you can understand
-   runs on iOS 4+ and Mac OS X 10.6+
-   just drag-and-drop .h and .m in your project
-   new BSD license

##### ... yet powerful

-   synchronous and asynchronous (block based) calls
-   easy to set request headers, cookies and POST data
-   easy to get response status, headers and encoding
-   file upload with progress block
-   fast and simple HTTP authentication

##### Usable in unit tests

You can fill a queue with fake responses to be consumed by requests started from unit tests.

##### Typical usage

    STHTTPRequest *r = [STHTTPRequest requestWithURLString:@"http://google.com"];
        
    r.completionBlock = ^(NSDictionary *headers, NSString *body) {
        // ...
    };
    
    r.errorBlock = ^(NSError *error) {
        // ...
    };
    
    [r startAsynchronous];

##### Starting a synchronous request

    NSError *error = nil;
    NSString *body = [r startSynchronousWithError:&error];

##### Getting HTTP data and metadata

    NSInteger     status   = r.responseStatus;
    NSDictionary *headers  = r.responseHeaders;
    NSString     *encoding = r.responseStringEncodingName;
    NSData       *data     = r.responseData;

##### Adding a request header

    [r addHeaderWithName:@"test" value:@"1234"];

##### Adding a request cookie

    [r addCookieWithName:@"test" value:@"1234"];

##### Setting a POST dictionary
    
    r.POSTDictionary = [NSDictionary dictionaryWithObject:@"1234" forKey:@"test"];

##### Setting credentials

    [r setUsername:@"test" password:@"1234"];

##### Uploading a file

    [r setFileToUpload:@"/tmp/photo.jpg" parameterName:@"photo"];
