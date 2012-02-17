//
//  CookieListDetailsViewController.m
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CookieListDetailsViewController.h"
#import "CookieListName.h"

@implementation CookieListDetailsViewController

@synthesize nameTextField;
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
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
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
    [self.nameTextField becomeFirstResponder];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        [self.nameTextField becomeFirstResponder];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate cookieListDetailsViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    CookieListName *cookieListName = [[CookieListName alloc] init];
    cookieListName.name = self.nameTextField.text;

    // Check for only spaces in a name as well as no name entered
    NSString *tempString = cookieListName.name;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString = [tempString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmedString length] == 0)  {
        cookieListName = nil;
        NSLog(@"Found only spaces for the list name.  Need to pop up an alert box.");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"The list name you entered did not contain any characters.  The list will not be added." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        
    }
    else  {
    //[self.delegate cookieListDetailsViewControllerDidSave:self];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
    cookieListName.sowSoftwareDateOrder = [dateFormat stringFromDate:now];
    }

    //NSLog(@"CookieListDetailViewController:done:cookieListName.sowSoftwareDateOrder : %@",cookieListName.sowSoftwareDateOrder);
    [self.delegate cookieListDetailsViewController:self didAddCookieList:cookieListName];
     
}

@end
