//
//  SettingsViewController.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "GlobalSettings.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize priceTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    self.priceTextField.text = globalSettings.cookiePrice;
}

- (void)viewDidUnload
{
    [self setPriceTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the user touches anywhere in the table cell, the keyboard will pop up.
    // This is needed because the text field doesn't completely fill the table cell.
    if (indexPath.section == 0) {
        [self.priceTextField becomeFirstResponder];
    }
    
}


- (IBAction)done:(id)sender  {
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    globalSettings.cookiePrice = self.priceTextField.text;
    NSLog(@"editSettings done. Setting global cookie price to %@", globalSettings.cookiePrice);
    [self.delegate settingsViewControllerDidSave:self];

}

- (IBAction)cancel:(id)sender {
    NSLog(@"editSettings cancel");
    [self.delegate settingsViewCOntrollerDidCancel:self];

}


@end
