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

@implementation CookieCountViewController

@synthesize cookiesAllInfo;
@synthesize listName;

- (void)calculateTotals  
{
    totalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
    totalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    for (GSCookie *gscookie in cookiesAllInfo) {
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
    
    self.navigationItem.title = listName;
    
    [super viewDidLoad];
    //self.navigationController.toolbarHidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self writeBarButtonTitle];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //NSLog(@"viewDidUnload");

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
    //NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //NSLog(@"viewDidDisappear");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [cookiesAllInfo count];
    }
    else  {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    NSString *sectionHeader = nil;
    
    if (section == 0)  {
        sectionHeader = @"Cookies";
    }
    else if (section == 1)  {
        sectionHeader = @"Totals";
    }
    
    return sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CookieCountCell";
    static NSString *TotalCellIdentifier = @"TotalCountCell";
    
    CookieCountCell *cell;
    
    if (indexPath.section == 0)  {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil) {
            cell = [[CookieCountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
        // Configure the cell...
        GSCookie *gscookie = [cookiesAllInfo objectAtIndex:indexPath.row];
        cell.cookieNameLabel.text = gscookie.name;
    
        NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
        cell.quantityLabel.text = [NSString stringWithFormat:@" %@ @ $%.2f = $%.2f", gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
        cell.stepper.value = [gscookie.quantity doubleValue];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //NSLog(@"Inside didSelectRowAtIndexPath");
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
    GSCookie *gscookie = [cookiesAllInfo objectAtIndex:path.row];
    gscookie.quantity = decimalNumber;
    [cookiesAllInfo replaceObjectAtIndex:path.row withObject:gscookie];
    //GSCookie *gscookie2 = [cookieNames objectAtIndex:path.row];
    //NSLog(@"did the object get replaced? %@  count %d", gscookie2.quantity,[cookieNames count]);
    
    NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
    cell.quantityLabel.text = [NSString stringWithFormat:@" %@ @ $%.2f = $%.2f", gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
    
    // TODO: Update the bottom the section with corect quantity and totals
    NSIndexPath *totalCookiesIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *totalMoniesIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    [self calculateTotals];
    CookieCountCell *totalCookiesCell = (CookieCountCell *)[table cellForRowAtIndexPath:totalCookiesIndex];
    totalCookiesCell.cookieNameLabel.text = [NSString stringWithFormat:@"Cookies: %@", totalNumberOfCookies];
    
    CookieCountCell *totalMoniesCell = (CookieCountCell *)[table cellForRowAtIndexPath:totalMoniesIndex];
    totalMoniesCell.cookieNameLabel.text = [NSString stringWithFormat:@"Monies: $%.2f", [totalMonies floatValue]];

    
}

- (IBAction)sendEmailFromCookieCount  {
    //NSLog(@"Here sending email in CookieCount");
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:[NSString stringWithFormat:@"%@ Cookie List Detail Report",listName]];
    NSMutableString *messageBody = [NSMutableString stringWithFormat:@"%@ Cookie List Detail Report\n\n",listName];
    [self calculateTotals];
    [messageBody appendFormat:@"Total Cookies: %@ \n", totalNumberOfCookies];
    [messageBody appendFormat:@"Total Monies: $%.2f \n\n", [totalMonies floatValue]];

    for (GSCookie *gscookie in cookiesAllInfo)
    {
        NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
        [messageBody appendFormat:@"%@: %@ @ $%.2f = $%.2f\n",gscookie.name, gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
    }
    
	[controller setMessageBody:messageBody isHTML:NO];
	[self presentModalViewController:controller animated:YES];

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

@end
