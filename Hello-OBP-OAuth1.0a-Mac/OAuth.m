//
//  OAuthController.m
//  HelloOAuthMac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//


// OBP API: https://github.com/OpenBankProject/OBP-API/wiki/OAuth-1.0-Server
// Sandbox: https://github.com/OpenBankProject/OBP-API/wiki/Sandbox

// Flow of OAuth
//1. Obtaining a request token: Open request url with consumer token and secret, get request token
//2. Redirecting the user: use token and local callback url as parameter (custom url scheme) and receive oauth_verifier
//3. Obtaining an access token: request access token to do authenticated access through callback response
//4. Accessing to protected resources


#import "OAuth.h"
#import "OAuthCore.h"
#import "STHTTPRequest.h"
#import "AppDelegate.h"
#import "MainViewController.h"

// 1. To get the values for the following fields, please register your client here:
// https://apisandbox.openbankproject.com/consumer-registration

#define OAUTH_CONSUMER_KEY @"1iz1zcsczwhkhyd3ztzb3i5whuubzetfqhfc52ve"
#define OAUTH_CONSUMER_SECRET_KEY @"p4li5mklyt1h43w3u0tx4w2evtn2yz3gmntyn2ty"
#define OAUTH_URL_SCHEME @"helloobp" // Your Application Name

#define OAUTH_AUTHENTICATE_URL @"https://apisandbox.openbankproject.com/"
#define OAUTH_BASE_URL @"https://apisandbox.openbankproject.com/obp/v1.2/"
#define OAUTH_CONSUMER_BANK_ID @"rbs" //Account of bank


@implementation OAuth

@synthesize accessToken;
@synthesize accessTokenSecret;
@synthesize verifier;

#pragma mark - Get Tokens

- (void)getRequestToken {
    
    NSString *lURL = [OAUTH_AUTHENTICATE_URL stringByAppendingString: @"oauth/initiate"];
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:lURL];
    
    [request setPOSTDictionary:[NSMutableDictionary dictionary]];  //set method to POST
	NSString *header = OAuthHeader([request url],
								   [request POSTDictionary]!=nil?@"POST":@"GET",
								   [@"" dataUsingEncoding:NSUTF8StringEncoding],
								   OAUTH_CONSUMER_KEY,
								   OAUTH_CONSUMER_SECRET_KEY,
								   nil,
								   nil,
								   nil, // oauth_verifier
								   OAuthCoreSignatureMethod_HMAC_SHA256,
								   [OAUTH_URL_SCHEME stringByAppendingString: @"://callback"]);
    
    [request setHeaderWithName:@"Authorization" value:header];
    
    request.completionBlock = ^(NSDictionary *headers, NSInteger status, NSString *body) {
        if (status == 200) {
           
            NSDictionary *response = [self parseQueryString:[body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if([[response valueForKey:@"oauth_callback_confirmed"] isEqualToString:@"true"]){
                requestToken = [response valueForKey:@"oauth_token"];
                requestTokenSecret = [response valueForKey:@"oauth_token_secret"];
                [self openBrowserAuthRequest];
            }
        }
    };
    request.errorBlock = ^(NSError *error, NSInteger status) {
        NSLog(@"status = %ld and Error= %@", (long)status, error);
    };
    
    [request startAsynchronous];
}

#pragma mark - Open Browser


- (void)openBrowserAuthRequest {
    
    NSString *lAuthenticationURL = [OAUTH_AUTHENTICATE_URL stringByAppendingString: @"oauth/authorize"];
    NSURL *url = [NSURL URLWithString:[self addQueryStringToUrlString:lAuthenticationURL withDictionary:[NSDictionary dictionaryWithObjectsAndKeys:requestToken, @"oauth_token", nil]]];
    [[NSWorkspace sharedWorkspace] openURL:url];
    
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    
    // Handler for custom url scheme events, our callback url
    NSURL *calledURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
        if ([[calledURL absoluteString] hasPrefix:OAUTH_URL_SCHEME]) {
            NSDictionary* parameters = [self parseQueryString:[calledURL query]];
            if (requestToken && [[parameters valueForKey:@"oauth_token"] isEqualTo:requestToken]) {
                verifier = [parameters valueForKey:@"oauth_verifier"];
        }
    }
    [self getAccessToken];
}

#pragma mark - Get Access Token

- (void)getAccessToken {
    
    NSString *lURL = [OAUTH_AUTHENTICATE_URL stringByAppendingString: @"oauth/token"];
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:lURL];
    
    [request setPOSTDictionary:[NSMutableDictionary dictionary]];  //set method to POST
	NSString *header = OAuthHeader([request url],
								   [request POSTDictionary]!=nil?@"POST":@"GET",
								   [@"" dataUsingEncoding:NSUTF8StringEncoding],
								   OAUTH_CONSUMER_KEY,
								   OAUTH_CONSUMER_SECRET_KEY,
								   requestToken,
								   requestTokenSecret,
								   verifier,
								   OAuthCoreSignatureMethod_HMAC_SHA256,
								   [OAUTH_URL_SCHEME stringByAppendingString: @"://callback"]);
        
    [request setHeaderWithName:@"Authorization" value:header];
    
    request.completionBlock = ^(NSDictionary *headers, NSInteger status, NSString *body) {
        if (status == 200) {
            NSDictionary *response = [self parseQueryString:[body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            accessToken = [response valueForKey:@"oauth_token"];
            accessTokenSecret = [response valueForKey:@"oauth_token_secret"];
            
            [self getResourceWithString];
        }
    };
    
    request.errorBlock = ^(NSError *error, NSInteger status) {
        NSLog(@"status = %ld and Error= %@", (long)status, error);
    };

    
    [request startAsynchronous];
}

#pragma mark - Get Resources

- (void)getResourceWithString {
    // 
    NSString *lURL = [NSString stringWithFormat: @"%@banks/%@/accounts/private",OAUTH_BASE_URL, OAUTH_CONSUMER_BANK_ID];
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:lURL];
	NSString *header = OAuthHeader([request url],
								   [request POSTDictionary]!=nil?@"POST":@"GET",
								   [@"" dataUsingEncoding:NSUTF8StringEncoding],
								   OAUTH_CONSUMER_KEY,
								   OAUTH_CONSUMER_SECRET_KEY,
								   accessToken,
								   accessTokenSecret,
								   nil, // oauth_verifier
								   OAuthCoreSignatureMethod_HMAC_SHA256,
								   nil); // callback
    
    [request setHeaderWithName:@"Authorization" value:header];
    request.completionBlock = ^(NSDictionary *headers, NSInteger status, NSString *body) {
        if (status == 200) {
            //NSLog(@"body = %@",body); // The OBP API returns JSON
            //store into user defaults for later access
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:accessToken forKey:kAccessTokenKeyForPreferences];
            [defaults setObject:accessTokenSecret forKey:kAccessSecretKeyForPreferences];
            [defaults setObject:body forKey:kJSON];
            [defaults synchronize];
        }
    };
    
    request.errorBlock = ^(NSError *error, NSInteger status) {
        NSLog(@"Status = %ld: Error= %@", (long)status, error);
    };
    
    [request startAsynchronous];
}


#pragma mark - Additions

-(NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

-(NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (CFStringRef)CFBridgingRetain(unencodedString);
    NSString *s = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8));
    CFRelease(originalStringRef);
    return s;
}


-(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}


@end
