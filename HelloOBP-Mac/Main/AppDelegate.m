//
//  AppDelegate.m
//  HelloOBP-Mac
//
//  Created by comp on 22.04.14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "AppDelegate.h"
// sdk
#import <OBPKit/OBPServerInfo.h>
#import <OBPKit/OBPWebViewProvider.h>
// prj
#import "DefaultServerDetails.h"
#import "MainViewController.h"



@interface  AppDelegate()
@property (nonatomic,strong) IBOutlet MainViewController *mainViewController;
@end



@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[OBPDefaultWebViewProvider configureToUseExternalWebViewer: NO
										withCallbackSchemeName: @"callback"
										andInstallCallbackHook: YES];

	if (nil == [OBPServerInfo firstEntryForAPIServer: kDefaultServer_APIBase])
	{
		OBPServerInfo*	serverInfo;
		serverInfo = [OBPServerInfo addEntryForAPIServer: kDefaultServer_APIBase];
		serverInfo.data = DefaultServerDetails();
	}

    // 1. Create the master View Controller
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];

    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.mainViewController.view];
    self.mainViewController.view.frame = ((NSView*)self.window.contentView).bounds;

}
@end


