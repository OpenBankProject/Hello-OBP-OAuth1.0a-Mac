//
//  MainViewController.m
//  HelloOBP-Mac
//
//  Created by comp on 8/13/14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "MainViewController.h"
// sdk
#import <OBPKit/OBPKit.h>
#import <STHTTPRequest/STHTTPRequest.h>
// prj
#import "DefaultServerDetails.h"



@interface MainViewController ()
{
	OBPSession*		_session;
    NSDictionary*	_accountsDict;
    NSArray*		_accountsList;
}
@end



@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_session == nil)
	{
		OBPServerInfo*	serverInfo = [OBPServerInfo defaultEntry];
		_session = [OBPSession sessionWithServerInfo: serverInfo];
		// leave _session.webViewProvider as default
	}
    
    //Check if already you are authenticated for OBP
    if(_session.valid){
        [self.viewConnect setHidden:YES];
        [self.viewData setHidden:NO];
		[self fetchAccounts];
    }
    else{
 
        [self.viewConnect setHidden:NO];
        [self.viewData setHidden:YES];
        //NSLog(@"Ups not connect");
    }
}

- (IBAction)connectToGitHub:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/OpenBankProject/Hello-OBP-OAuth1.0a-Mac/blob/master/README.md"]];
}

#pragma mark -

-(IBAction)connect:(id)sender{
    
    [_session validate:
		^(NSError * error) {
			BOOL connected = error == nil && _session.valid;
			if (connected)
				[self fetchAccounts];
            [self.viewConnect setHidden: connected];
            [self.viewData setHidden: !connected];
		}
	];


}

- (IBAction)logOut:(id)sender {
    if ([_session valid]) {
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
        [_session invalidate];
        [self.viewConnect setHidden:NO];
        [self.viewData setHidden:YES];
        
    }
}

#pragma mark -

- (void)fetchAccounts {

    NSString*		requestPath;

	requestPath = [NSString stringWithFormat: @"banks/%@/accounts/private", OAUTH_CONSUMER_BANK_ID];

	HandleOBPMarshalData	resultHandler = 
		^(id deserializedObject, NSString* responseBody) {
			_accountsDict = deserializedObject;
			dispatch_async(dispatch_get_main_queue(), ^{
				[self loadAccounts];
			});
		};

	[_session.marshal getResourceAtAPIPath: requestPath withOptions: nil
						  forResultHandler: resultHandler orErrorHandler: nil];
}

- (void)loadAccounts
{
	_accountsList = _accountsDict[@"accounts"];
	[self.accountsTableView reloadData];
}

#pragma mark -

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

    // Since this is a single-column table view, this would not be necessary.
    if( [tableColumn.identifier isEqualToString:@"Accounts"] )
    {
        NSString *idAccount= [[_accountsList objectAtIndex:row] objectForKey:@"id"];
        cellView.textField.stringValue = idAccount;
        return cellView;
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _accountsList.count;
}

#pragma mark -

- (IBAction)quitApp:(id)sender {
	[_session invalidate];
    [[NSApplication sharedApplication] terminate:nil];
}

@end
