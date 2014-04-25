//
//  AppDelegate.h
//  Hello-OBP-OAuth1.0a-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OAuth.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    OAuth *_oauth;
}


@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) OAuth *oauth;

@property (assign) IBOutlet NSButton *ConnectionOBP;
@property (assign) IBOutlet NSTextField *message;

-(IBAction)connect:(id)sender;



@end
