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
#import "GlobalSettings.h"
#import "AppData.h"

@implementation MainTableViewController

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
    
    NSLog(@"Here in MainTableViewController:viewDidLoad");
    
    // Example of how to get the application delegate object
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    //NSLog(@"Here in MainTableViewController:viewWillAppear");
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
    return (YES);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppData *sharedAppData = [AppData sharedData];
    return [sharedAppData.cookieLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    AppData *sharedAppData = [AppData sharedData];
    //cell.textLabel.text = [[sharedAppData.cookieLists objectAtIndex:indexPath.row] name];
    cell.textLabel.text = [sharedAppData getListName:indexPath.row];
    
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Here deleting a list");
        AppData *sharedAppData = [AppData sharedData];
        //CookieListName *cookieListName = [sharedAppData.cookieLists objectAtIndex:indexPath.row];
        //[sharedAppData.allTheData removeObjectForKey:[sharedAppData getListName:indexPath.row]];
        //[sharedAppData.cookieLists removeObjectAtIndex:indexPath.row];
        [sharedAppData removeCookieList:indexPath.row];
        [sharedAppData writeDataToFile];
        //NSLog(@"commitEditingStyle:cookieLists count: %d",[sharedAppData.cookieLists count]);
        NSLog(@"commitEditingStyle:cookieLists count: %d",[sharedAppData getNumberOfCookieLists]);

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
    AppData *sharedAppData = [AppData sharedData];
    //CookieListName *fromCookieListName = [sharedAppData.cookieLists objectAtIndex:fromIndexPath.row];
    //fromCookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",toIndexPath.row];
    [sharedAppData setSowSoftwareListOrder:fromIndexPath.row order:toIndexPath.row];   
    //CookieListName *toCookieListName = [sharedAppData.cookieLists objectAtIndex:toIndexPath.row];
    //toCookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",fromIndexPath.row];
    [sharedAppData setSowSoftwareListOrder:toIndexPath.row order:fromIndexPath.row];

    
    // Update the array
    [sharedAppData.cookieLists exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    // Write the data
    [sharedAppData writeDataToFile];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CookieCountViewController *cookieCountViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cookieCountTable"];

    // Just pass the index path that was selected
    cookieCountViewController.selectIndexPath = indexPath;
    [self.navigationController pushViewController:cookieCountViewController animated:YES];
     
}

- (void) settingsViewController:(SettingsViewController *)controller  {
    NSLog(@"MainTableViewController:settingsViewController");
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - CookieListDetailsViewControllerDelegate methods
- (void)cookieListDetailsViewControllerDidCancel:(CookieListDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This delegate method is called when a new list is created
- (void)cookieListDetailsViewController:(CookieListDetailsViewController *)controller didAddCookieList:(CookieListName *)cookieListName  {
        
    // Initialize the hash with the name as well as data with all quantities set to 0 only if no data is loaded from file
    AppData *sharedAppData = [AppData sharedData];

    if (cookieListName != nil) {
        
    if (![sharedAppData doesCookieListNameExist:cookieListName.name]) {
        [sharedAppData addNewCookieList:cookieListName.name];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sharedAppData getNumberOfCookieLists] - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      
        // After adding the list to the data structure, write the data out
        [sharedAppData writeDataToFile];
 
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

# pragma mark
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
    AppData *sharedAppData = [AppData sharedData];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
    
	[controller setSubject:[NSString stringWithString:@"All Cookie Lists Detail Report\n\n"]];
	[controller setMessageBody:[sharedAppData createAllListSummary] isHTML:NO];
	[self presentModalViewController:controller animated:YES];
     
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SettingsViewControllerDelegate
- (void) settingsViewController:(SettingsViewController *)controller didChangePrice:(NSString *)price  {
    
    if (price != nil)  {
        GlobalSettings *globalSettings = [GlobalSettings sharedManager];
        globalSettings.cookiePrice = price;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) settingsViewControllerDidCancel:(SettingsViewController *)controller  {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
