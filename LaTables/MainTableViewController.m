//
//  MainTableViewController.m
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"
#import "CookieCountViewController.h"
#import "AppDelegate.h"
#import "GSCookie.h"
#import "SettingsViewController.h"

@implementation MainTableViewController

@synthesize cookieLists;
@synthesize cookieNamesAndPrice;
@synthesize allTheData;

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

-(void)setupArray{
    
    cookieLists = [[NSMutableArray alloc] init];
}

-(void)setupCookieNames  {
    
    // This should be the default, but can be changed in preferences.
    // Store in a plist file
    cookieNamesAndPrice = [[NSMutableDictionary alloc] init];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Thin Mints"];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Samoas"];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Do-si-dos"];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Tagalongs"];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Savannah Smiles"];
    [cookieNamesAndPrice setObject:@"3.50" forKey:@"Trefoils"];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setupArray];
    [self setupCookieNames];
    [super viewDidLoad];
    
    NSLog(@"Here in MainTableViewController:viewDidLoad");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mainController = self;
    [appDelegate readData];
    
    if (allTheData == nil)  {
        NSLog(@"initializing allTheData");
        allTheData = [[NSMutableDictionary alloc] init];
    }
    
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Here in MainTableViewController:viewWillAppear");
    //self.navigationController.toolbarHidden = YES;
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (YES);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 5;
    NSInteger c = [cookieLists count];
    NSLog(@"numberOfRowsInSection:cookieLists count: %d",c);
    return [self.cookieLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    CookieListName *cookieListName = [self.cookieLists objectAtIndex:indexPath.row];
    //NSLog(@"Here: %@", cookieListName.name);
    cell.textLabel.text = cookieListName.name;
    
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //NSLog(@"MainTableViewController:canEditRowAtIndexPath");
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Here deleting a list");
        CookieListName *cookieListName = [self.cookieLists objectAtIndex:indexPath.row];
        [allTheData removeObjectForKey:cookieListName.name];
        [self.cookieLists removeObjectAtIndex:indexPath.row];
        NSLog(@"commitEditingStyle:cookieLists count: %d",[self.cookieLists count]);

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"MaintTableViewController:commitEditingStyle editing Style is UITableViewCellEditingStyleInsert");
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"MainTableViewController:moveRowAtIndexPath");
    
    // Update the cookieListName.sowSoftwareListOrder
    CookieListName *fromCookieListName = [self.cookieLists objectAtIndex:fromIndexPath.row];
    fromCookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",toIndexPath.row];
    CookieListName *toCookieListName = [self.cookieLists objectAtIndex:toIndexPath.row];
    toCookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",fromIndexPath.row];

    
    // Update the array
    [cookieLists exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    NSLog(@"MainTableViewController:canMoveRowAtIndexPath");
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CookieCountViewController *cookieCountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cookieCountTable"];
    
    // How to know the cookie list name to pull the next screens data out of the associative array
    CookieListName *cookieListName = [self.cookieLists objectAtIndex:indexPath.row];
    NSLog(@"In MainTableViewController:didSelectRowAtIndexPath cookieListName: %@", cookieListName.name);
    
    // Pass along the cookie names and prices
    cookieCountViewController.cookiesAllInfo = [allTheData objectForKey:cookieListName.name];
    cookieCountViewController.listName = cookieListName.name;
    
    [self.navigationController pushViewController:cookieCountViewController animated:YES];
     
}

- (void) settingsViewController:(SettingsViewController *)controller  {
    NSLog(@"MainTableViewController:settingsViewController");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cookieListDetailsViewControllerDidCancel:(CookieListDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cookieListDetailsViewController:(CookieListDetailsViewController *)controller didAddCookieList:(CookieListName *)cookieListName  {
        
    // Initialize the hash with the name as well as data with all quantities set to 0 only if no data is loaded from file
    //NSArray *keysOfAllTheData = [allTheData allKeys];
    if (cookieListName != nil) {
        
    if ([allTheData objectForKey:cookieListName.name] == nil) {
    
        NSArray *sortedKeys = [[cookieNamesAndPrice allKeys] sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];  
        NSMutableArray *initialCookieInfo = [NSMutableArray arrayWithCapacity:[sortedKeys count]];
    
      
        NSString *STARTING_QTY = @"0";
        GSCookie *gscookie;
    
        for (NSString *key in sortedKeys)  {
            //NSLog(@"key: %@", key);

        
            gscookie = [[GSCookie alloc] init];
            gscookie.name = key;
            gscookie.price = [[NSDecimalNumber alloc] initWithString:[cookieNamesAndPrice objectForKey:key]];
            gscookie.quantity = [[NSDecimalNumber alloc] initWithString:STARTING_QTY];
            [initialCookieInfo addObject:gscookie];
        }

        // Need to determine the value for sowsoftwareListOrder
        cookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",[self.cookieLists count]];
        NSLog(@"cookieListName: %@   sowsoftwareListOrder: %@", cookieListName.name, cookieListName.sowSoftwareListOrder);
        [self.cookieLists addObject:cookieListName];
        [allTheData setObject:initialCookieInfo forKey:cookieListName.name];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.cookieLists count] - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 
    }
    else  {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:@"Duplicate list names are not allowed." 
                                                    delegate:nil 
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
        [message show];
    }
    }
    else  {
        NSLog(@"MainTableViewController:cookieListDetailsViewController - cookieListName was nil");
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPlayer"])
    {        
        NSLog(@"MainTableViewController:prepareForSegue AddPlayer");
        UINavigationController *navigationController = segue.destinationViewController;
        CookieListDetailsViewController *cookieListDetailsViewController = [[navigationController viewControllers]objectAtIndex:0];
        cookieListDetailsViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"EditSettings"])
    {
        NSLog(@"MainTableViewController:prepareForSegue EditSettings");
        UINavigationController *navigationController = segue.destinationViewController;
        SettingsViewController *settingsViewController = [[navigationController viewControllers]objectAtIndex:0];
        settingsViewController.delegate = self;
    }
 

}

- (IBAction)sendEmailFromMain  {
    //NSLog(@"Here sending email in Main");
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
    
	[controller setSubject:[NSString stringWithString:@"All Cookie Lists Detail Report\n\n"]];
    
    NSMutableString *messageBody = [NSMutableString stringWithString:@"All Cookie Lists Detail Report\n\n"];

    NSDecimalNumber *grandTotalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *grandTotalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];

    NSMutableDictionary *grandTotalEachType = [[NSMutableDictionary alloc] init];
    
    NSArray *keysOfAllTheData = [allTheData allKeys];
    for (NSString *key in keysOfAllTheData)  {
        
        NSDecimalNumber *totalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
        NSDecimalNumber *totalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];

        [messageBody appendFormat:@"%@ Cookie List Detail Report\n\n",key];
        
        //[messageBody appendFormat:@"Total Cookies: %@ \n", totalNumberOfCookies];
        //[messageBody appendFormat:@"Total Monies: $%.2f \n\n", [totalMonies floatValue]];
    
        for (GSCookie *gscookie in [allTheData objectForKey:key])
        {
            NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
            [messageBody appendFormat:@"%@: %@ @ $%.2f = $%.2f\n",gscookie.name, gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
            totalNumberOfCookies = [totalNumberOfCookies decimalNumberByAdding:gscookie.quantity];
            totalMonies = [totalNumberOfCookies decimalNumberByMultiplyingBy:gscookie.price];
            
            // Check if the cookie name is in grandTotalEachType.  If not, set the quantity.  If so, add the quantity
            if ([grandTotalEachType objectForKey:gscookie.name]) {
                NSDecimalNumber *t = [grandTotalEachType objectForKey:gscookie.name];
                //NSLog(@"Cookie name exists: %@  with quantity %@",gscookie.name,t);

                t = [t decimalNumberByAdding:gscookie.quantity];
                [grandTotalEachType setObject:t forKey:gscookie.name];
            }
            else  {
                [grandTotalEachType setObject:gscookie.quantity forKey:gscookie.name];
            }

        }
        [messageBody appendFormat:@"\nTotal Cookies: %@ \n", totalNumberOfCookies];
        [messageBody appendFormat:@"Total Monies: $%.2f \n\n", [totalMonies floatValue]];

        [messageBody appendString:@"\n\n"];
        
        grandTotalNumberOfCookies = [grandTotalNumberOfCookies decimalNumberByAdding:totalNumberOfCookies];
        grandTotalMonies = [grandTotalMonies decimalNumberByAdding:totalMonies];
        

    }
    
    [messageBody appendFormat:@"\nGrand Total Cookies: %@ \n", grandTotalNumberOfCookies];
    [messageBody appendFormat:@"Grand Total Monies: $%.2f \n\n", [grandTotalMonies floatValue]];
    
    [messageBody appendString:@"\n\n"];
    
    [messageBody appendFormat:@"\nGrand Total For Each Cookie Type:\n"];
    NSArray *keys = [[grandTotalEachType allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    for (NSString *key in keys)  {
        [messageBody appendFormat:@"%@ : %@\n",key,[grandTotalEachType objectForKey:key]];
    }
    
    [messageBody appendString:@"\n\n"];
    

	[controller setMessageBody:messageBody isHTML:NO];
	[self presentModalViewController:controller animated:YES];
     
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SettingsViewControllerDelegate

- (void) settingsViewControllerDidSave:(SettingsViewController *)controller  {
    NSLog(@"MainTableViewController:settingsViewControllerDidSave - Done button pressed in Settings");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) settingsViewCOntrollerDidCancel:(SettingsViewController *)controller  {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
