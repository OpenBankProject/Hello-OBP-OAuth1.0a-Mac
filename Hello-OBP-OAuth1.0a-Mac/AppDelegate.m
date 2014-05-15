//
//  AppDelegate.m
//  Hello-OBP-OAuth1.0a-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize oauth = _oauth;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"applicationDidFinishLaunching");
    // Insert code here to initialize your application
    _oauth = [[OAuth alloc] init];
    
    //register custom url scheme for callbacks
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:_oauth andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    //Check if already you are authenticated for OBP
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey: kAccessTokenKeyForPreferences]){
        [self.viewConnect setHidden:YES];
        [self.viewData setHidden:NO];
        [self.textJSON setString:[defaults valueForKey:kJSON]];
    }
	else{
        
        [self.viewConnect setHidden:NO];
        [self.viewData setHidden:YES];
        //NSLog(@"Ups not connect");
    }
}

- (IBAction)connectToGitHub:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/OpenBankProject/Hello-OBP-OAuth1.0a-Mac"]];
}


-(IBAction)connect:(id)sender{
  
    [_oauth getRequestToken];
    
}

- (IBAction)logOut:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey: kAccessTokenKeyForPreferences]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Log out"];
        [alert setInformativeText:@"Are you sure you want to clear Data?"];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        if ([alert runModal] != NSAlertFirstButtonReturn) // Cancel
        {
            return;
        }
        [defaults removeObjectForKey: kAccessSecretKeyForPreferences];
        [defaults removeObjectForKey: kAccessTokenKeyForPreferences];
        [defaults synchronize];
        [self.viewConnect setHidden:NO];
        [self.viewData setHidden:YES];

    }
}

@end
