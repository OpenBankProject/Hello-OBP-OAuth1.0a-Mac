//
//  OAuth.h
//  Hello-OBP-OAuth1.0a-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAccessTokenKeyForPreferences @"accessToken"
#define kAccessSecretKeyForPreferences @"accessTokenSecret"

@interface OAuth : NSObject {
   
    NSMutableString *requestToken;
    NSMutableString *requestTokenSecret;
    
}

@property (nonatomic, retain) NSMutableString *accessToken;
@property (nonatomic, retain) NSMutableString *accessTokenSecret;
@property (nonatomic, retain) NSMutableString *verifier;

- (void)getRequestToken;
- (void)openBrowserAuthRequest;
- (void)getAccessToken;
- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent;

@end
