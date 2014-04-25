//
//  AppDelegate.m
//  Hello-OBP-OAuth1.0a-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize ConnectionOBP;
@synthesize oauth = _oauth;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _oauth = [[OAuth alloc] init];
    //register custom url scheme for callbacks
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:_oauth andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    //Check if already you are authenticated for OBP
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"kAccessTokenKeyForPreferences = %@", kAccessTokenKeyForPreferences);
	if(![defaults valueForKey: kAccessTokenKeyForPreferences]){
        [self.message setHidden:YES];
    }
	else{
        [self.message setHidden:NO];
	}

}


-(IBAction)connect:(id)sender{
   NSLog(@"Hello connect");
    
    //AppDelegate *ldelegate = (AppDelegate *)[NSApp delegate];
    [_oauth getRequestToken];
    
}


@end
