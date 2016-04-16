//
//  AppDelegate.m
//  HelloOBP-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface  AppDelegate()
    @property (nonatomic,strong) IBOutlet MainViewController *mainViewController;
@end

@implementation AppDelegate

@synthesize oauth = _oauth;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //NSLog(@"applicationDidFinishLaunching");
    // Insert code here to initialize your application
    // 1. Create the master View Controller
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //initialize oauth
    _oauth = [[OAuth alloc] init];
    
    // observing a key in the preferences that holds the access token and data
    [defaults addObserver:self forKeyPath:kJSON options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];

    //register custom url scheme for callbacks
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:_oauth andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.mainViewController.view];
    self.mainViewController.view.frame = ((NSView*)self.window.contentView).bounds;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //NSLog(@"observeValueForKeyPath");
    //Check if already you are authenticated for OBP and there is data
    if ([keyPath isEqualToString: kJSON])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults valueForKey: kJSON]){
            [self.mainViewController.viewConnect setHidden:YES];
            [self.mainViewController.viewData setHidden:NO];
            [self.mainViewController UpdateAccounts];
        }
        else{
            [self.mainViewController.viewConnect setHidden:NO];
            [self.mainViewController.viewData setHidden:YES];
        }
    }
}

@end
