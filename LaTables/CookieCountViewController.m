//
//  CookieCountViewController.m
//  LaTables
//
//  Created by Shelley Barnes on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CookieCountViewController.h"
#import "GSCookie.h"
#import "CookieCountCell.h"
#import "AppData.h"
#import "CookieListName.h"

@implementation CookieCountViewController

@synthesize selectIndexPath;
@synthesize mainTableView;
- (void)calculateTotals  
{
    totalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
    totalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    AppData *sharedAppData = [AppData sharedData];

    CookieListName *cookieListName = [sharedAppData.cookieLists objectAtIndex:self.selectIndexPath.row];

    //NSLog(@"cookie list name %@", cookieListName.name);
    NSMutableArray *allCookies = [sharedAppData.allTheData objectForKey:cookieListName.name];
    for (GSCookie *gscookie in allCookies) {
        totalNumberOfCookies = [totalNumberOfCookies decimalNumberByAdding:gscookie.quantity];
        totalMonies = [totalNumberOfCookies decimalNumberByMultiplyingBy:gscookie.price];
    }
      
}
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
    [self calculateTotals];
    //[self writeBarButtonTitle];
 
    if ([MFMailComposeViewController canSendMail])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    AppData *sharedAppData = [AppData sharedData];
    self.navigationItem.title = [sharedAppData getListName:selectIndexPath.row];
    
    // This will hopefully make the title bar editable on a double tap
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setListTitle)];
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [self.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer];
    
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self writeBarButtonTitle];

}

- (void)setListTitle  {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 25, 200, 30)];
    //[textField setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    [textField setFont:[UIFont systemFontOfSize:17.0]];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setKeyboardType:UIKeyboardTypeDefault];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [textField setPlaceholder:self.title];
    [textField setTag:2357];
    [textField setAutoresizingMask:UIViewAutoresizingNone];
    [textField setOpaque:NO];
    [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.navigationController.view addSubview:textField];
    [textField becomeFirstResponder];
}

- (void)textFieldDone:(UITextField *)textField  {
    
    if (textField.tag == 2357 && ![textField.text isEqualToString:@""]) {
        
        self.title = textField.text;
        
        // Need to update the main controller view
        // call tableview releoadData for the MainTableViewController
        
        // Save off the data
        AppData *sharedAppData = [AppData sharedData];
        [sharedAppData updateListName:self.selectIndexPath.row withName:textField.text];        
        [sharedAppData writeDataToFile];
        
        [self.mainTableView reloadData];
        
        
    }
    
    [textField resignFirstResponder];
    [textField setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSLog(@"[DEBUG] CookieCountViewController:viewDidUnload");
    
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
    AppData *sharedAppData = [AppData sharedData];
    [sharedAppData writeDataToFile];
    [super viewWillDisappear:animated];
    NSLog(@"[DEBUG] CookieCoutViewController:viewWillDisappear");
    
    // Need to dismiss the title bar text box that is used to change the list name.
    // If the user hits the back button before selecting Done.
    // Don't know if these blind calls are ok or if I need to check if it is even active or displayed
    [[self.navigationController.view viewWithTag:2357] resignFirstResponder];
    [[self.navigationController.view viewWithTag:2357] setHidden:YES];
 
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"[DEBUG] CookieCountViewController:viewDidDisappear");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddNotes"])
    {                
        AppData *sharedAppData = [AppData sharedData];

        CookieListNotesViewController *cookieListNotesViewController = segue.destinationViewController;
        cookieListNotesViewController.delegate = self;
        //cookieListNotesViewController.listNotes = [[sharedAppData.cookieLists objectAtIndex:self.selectIndexPath.row] sowSoftwareListNotes];
        cookieListNotesViewController.listNotes = [sharedAppData getListNotes:selectIndexPath.row];
        
    }
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        AppData *sharedAppData = [AppData sharedData];
        
        return [sharedAppData getNumberOfCookiesForList:self.selectIndexPath.row];

    }
    else if (section == 2)  {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    NSString *sectionHeader = nil;
    
    if (section == 0)  {
        sectionHeader = @"Cookies";
    }
    else if (section == 2)  {
        sectionHeader = @"Donation";
    }
    else if (section == 1)  {
        sectionHeader = @"Cookie Totals";
    }
    
    return sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CookieCountCell";
    static NSString *TotalCellIdentifier = @"TotalCountCell";
    static NSString *DonationCellIdentifier = @"DonationCountCell";

    
    CookieCountCell *cell;
    AppData *sharedAppData = [AppData sharedData];
    
    if (indexPath.section == 0)  {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil) {
            cell = [[CookieCountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
        // Configure the cell...
        GSCookie *gscookie = [sharedAppData getGSCookieForList:self.selectIndexPath.row cookieIndex:indexPath.row];
        cell.cookieNameLabel.text = gscookie.name;
    
        NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
        cell.quantityLabel.text = [NSString stringWithFormat:@" %@ @ $%.2f = $%.2f", gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
        cell.stepper.value = [gscookie.quantity doubleValue];
    }
    else if (indexPath.section == 2)  {
        cell = [tableView dequeueReusableCellWithIdentifier:DonationCellIdentifier];
        
        if (cell == nil) {
            cell = [[CookieCountCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DonationCellIdentifier];
        }
        
        
        cell.cookieNameLabel.text = [NSString stringWithFormat:@"$ "];
        // Need to set donation amount from file
        cell.donationAmount.text = [sharedAppData getDonation:self.selectIndexPath.row];
        [cell.donationAmount addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
    }
    else if (indexPath.section == 1)  {
        cell = [tableView dequeueReusableCellWithIdentifier:TotalCellIdentifier];
        
        if (cell == nil) {
            cell = [[CookieCountCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TotalCellIdentifier];
        }
        
        [self calculateTotals];

        if (indexPath.row == 0) {
            cell.cookieNameLabel.text = [NSString stringWithFormat:@"Cookies: %@", totalNumberOfCookies];
        }
        else if (indexPath.row == 1)  {
            cell.cookieNameLabel.text = [NSString stringWithFormat:@"Monies: $%.2f", [totalMonies floatValue]];
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the user touches anywhere in the table cell, the keyboard will pop up.
    // This is needed because the text field doesn't completely fill the table cell.
    if (indexPath.section == 2) {
        CookieCountCell *cell = (CookieCountCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.donationAmount becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60;
}

- (IBAction)stepperChangeValue:(UIStepper *)sender  {
    double value = [sender value];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithDouble:value];
    
    //NSLog (@"Performing stepper action: %d", (int)value);
    CookieCountCell *cell = (CookieCountCell *)[[sender superview] superview];
    
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *path = [table indexPathForCell:cell];
    
    //NSLog(@"pressed with row %d",path.row);
    AppData *sharedAppData = [AppData sharedData];
    
    CookieListName *cookieListName = [sharedAppData.cookieLists objectAtIndex:self.selectIndexPath.row];
    
    NSMutableArray *allCookies = [sharedAppData.allTheData objectForKey:cookieListName.name];
    
    GSCookie *gscookie = [allCookies objectAtIndex:path.row];

    //GSCookie *gscookie = [cookiesAllInfo objectAtIndex:path.row];
    gscookie.quantity = decimalNumber;
    //[allCookies replaceObjectAtIndex:path.row withObject:gscookie];
        
    NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
    cell.quantityLabel.text = [NSString stringWithFormat:@" %@ @ $%.2f = $%.2f", gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
    
    NSIndexPath *totalCookiesIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *totalMoniesIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    [self calculateTotals];

    CookieCountCell *totalCookiesCell = (CookieCountCell *)[table cellForRowAtIndexPath:totalCookiesIndex];
    totalCookiesCell.cookieNameLabel.text = [NSString stringWithFormat:@"Cookies: %@", totalNumberOfCookies];
    
    CookieCountCell *totalMoniesCell = (CookieCountCell *)[table cellForRowAtIndexPath:totalMoniesIndex];
    totalMoniesCell.cookieNameLabel.text = [NSString stringWithFormat:@"Monies: $%.2f", [totalMonies floatValue]];
    totalMoniesCell.quantityLabel.text = @"This does not include donations";

    
}

- (IBAction)sendEmailFromCookieCount  {
    //NSLog(@"Here sending email in CookieCount");

    AppData *sharedAppData = [AppData sharedData];
    
    CookieListName *cookieListName = [sharedAppData.cookieLists objectAtIndex:self.selectIndexPath.row];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:[NSString stringWithFormat:@"%@ Cookie List Detail Report",cookieListName.name]];

	[controller setMessageBody:[sharedAppData createSummaryForOneList:cookieListName] isHTML:NO];
	[self presentModalViewController:controller animated:YES];

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

# pragma mark - CookieListNotesViewControllerDelegate methods
- (void)cookieListNotesViewControllerDidCancel:(CookieListNotesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cookieListNotesViewController:(CookieListNotesViewController *)controller didUpdateNotes:(NSString *)theListNotes  {
    
    AppData *sharedAppData = [AppData sharedData];

    [sharedAppData setListNotes:self.selectIndexPath.row :theListNotes];
    
    [sharedAppData writeDataToFile];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldFinished:(id)sender  {
    NSLog(@"[DEBUG] CookieCountViewController:textFieldFinished");
    NSString *regex = @"^\\d+\\.\\d\\d";
    NSPredicate *valtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    CookieCountCell *cell = (CookieCountCell *)[[sender superview] superview];

    BOOL ret = [valtest evaluateWithObject:cell.donationAmount.text];

    NSDecimalNumber *topPrice = [NSDecimalNumber decimalNumberWithString:@"999.00"];

    NSDecimalNumber *theEnteredPrice = [NSDecimalNumber decimalNumberWithString:cell.donationAmount.text];

    AppData *sharedAppData = [AppData sharedData];

    // If the price is not in the form d.dd or is above 999.00
    if ((!ret) || ([theEnteredPrice compare:topPrice] == NSOrderedDescending) ) {
        
        // TODO Need to set it to what it was before
        cell.donationAmount.text = [sharedAppData getDonation:self.selectIndexPath.row];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"The price you entered is not a valid price." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
    }
        
    [sharedAppData setDonation:self.selectIndexPath.row :cell.donationAmount.text];

    [sharedAppData writeDataToFile];
    
    [sender resignFirstResponder];
}
@end
