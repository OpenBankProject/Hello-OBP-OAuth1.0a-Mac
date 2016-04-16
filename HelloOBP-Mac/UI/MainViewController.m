//
//  MainViewController.m
//  HelloOBP-Mac
//
//  Created by comp on 8/13/14.
//  Copyright (c) 2014 TESOBE. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController () {
    NSDictionary *accounts;
    NSArray *account;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    //NSLog(@"awakeFromNib");
    
    //Check if already you are authenticated for OBP
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey: kAccessTokenKeyForPreferences]){
        [self.viewConnect setHidden:YES];
        [self.viewData setHidden:NO];
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


-(IBAction)connect:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    [appDelegate.oauth getRequestToken];

    
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
-(void) UpdateAccounts{
    //NSLog(@"UpdateAccounts say Hi");

    //Parse JSON to take the Accounts inside the array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *json = [defaults valueForKey:kJSON];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    accounts = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    account = [accounts objectForKey: @"accounts"];
    [self.accountsTableView reloadData];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];

    // Since this is a single-column table view, this would not be necessary.
    if( [tableColumn.identifier isEqualToString:@"Accounts"] )
    {
        NSString *idAccount= [[account objectAtIndex:row] objectForKey:@"id"];
        cellView.textField.stringValue = idAccount;
        return cellView;
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return account.count;
}


- (IBAction)quitApp:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

@end
