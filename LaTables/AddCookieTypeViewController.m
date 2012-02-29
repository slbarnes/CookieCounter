//
//  AddCookieTypeViewController.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCookieTypeViewController.h"


@implementation AddCookieTypeViewController
@synthesize cookieTypeToAdd;
@synthesize delegate;

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
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidUnload
{
    [self setCookieTypeToAdd:nil];
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
    [self.cookieTypeToAdd becomeFirstResponder];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        [self.cookieTypeToAdd becomeFirstResponder];
}

#pragma mark - Table view delegate


- (IBAction)cancel:(id)sender  {
    
    [self.delegate addCookieTypeViewControllerDidCancel:self];

}

- (IBAction)done:(id)sender  {
        
    // Check for only spaces in a name as well as no name entered
    NSString *cookieType = self.cookieTypeToAdd.text;
    NSString *tempString = cookieType;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedString length] == 0)  {
        cookieType = nil;
        //NSLog(@"Found only spaces for the new cookie type.  Need to pop up an alert box.");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"The cookie type you entered did not contain any characters.  The cookie type will not be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        
    }    
    
    //[self.delegate addCookieTypeViewControllerDidSave:self];
    [self.delegate addCookieTypeViewController:self didAddCookieType:cookieType];

}



@end
