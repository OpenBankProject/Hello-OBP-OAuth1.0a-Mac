//
//  MainViewController.h
//  Hello-OBP-OAuth1.0a-Mac
//
//  Created by comp on 8/13/14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "OAuth.h"

@interface MainViewController : NSViewController

@property (assign) IBOutlet NSTableView *accountsTableView;

@property (strong, nonatomic) IBOutlet NSView *viewConnect;
@property (strong, nonatomic) IBOutlet NSButton *linkOBP;
@property (strong, nonatomic) IBOutlet NSButton *ConnectionOBP;

@property (strong, nonatomic) IBOutlet NSView *viewData;
@property (strong, nonatomic) IBOutlet NSButton *logOut;

-(void) UpdateAccounts;

- (IBAction)connect:(id)sender;

- (IBAction)connectToGitHub:(id)sender;

- (IBAction)logOut:(id)sender;


@end
