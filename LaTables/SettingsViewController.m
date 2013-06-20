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
    [self.priceTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (IBAction)textFieldFinished:(id)sender  {
    
    NSLog(@"[DEBUG] SettingsViewController:textFieldFinished");
    NSString *regex = @"^\\d+\\.\\d\\d";
    NSPredicate *valtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL ret = [valtest evaluateWithObject:self.priceTextField.text];
    NSDecimalNumber *topPrice = [NSDecimalNumber decimalNumberWithString:@"999.00"];
    NSDecimalNumber *theEnteredPrice = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];
    // If the price is not in the form d.dd or is above 999.00
    if ((!ret) || ([theEnteredPrice compare:topPrice] == NSOrderedDescending) ) {
        
        GlobalSettings *globalSettings = [GlobalSettings sharedManager];
        self.priceTextField.text = globalSettings.cookiePrice;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"The price you entered is not a valid price." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
    }

    [sender resignFirstResponder];
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
    NSLog(@"viewWillDisappear");
    [self.priceTextField resignFirstResponder];
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
    if (indexPath.section == 2)  {
        
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        [controller setToRecipients:[[NSArray alloc] initWithObjects:@"sowsoftware@gmail.com", nil]];
        [controller setSubject:@"CookieCount Feedback"];
        NSString *messageBody = @"Thank you for your feedback.\n\n--- System Information ---\n --- Please do not delete ---\nName: CookieCount";
        messageBody = [messageBody stringByAppendingString:@"\nVersion: "];
        messageBody = [messageBody stringByAppendingString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        messageBody = [messageBody stringByAppendingString:@"\nDevice Model: "];
        messageBody = [messageBody stringByAppendingString:[[UIDevice currentDevice] model]];
        messageBody = [messageBody stringByAppendingString:@"\nDevice System: "];
        messageBody = [messageBody stringByAppendingString:[[UIDevice currentDevice] systemName]];
        messageBody = [messageBody stringByAppendingString:@"\nDevice OS Version: "];
        messageBody = [messageBody stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
        messageBody = [messageBody stringByAppendingString:@"\n--- End System Information ---\n\n"];

        [controller setMessageBody:messageBody isHTML:NO];

        [self presentModalViewController:controller animated:YES];

        
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)done:(id)sender  {
    NSLog(@"Here in done");
    NSString *regex = @"^\\d+\\.\\d\\d";
    NSPredicate *valtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL ret = [valtest evaluateWithObject:self.priceTextField.text];
    if (ret) {
        [self.delegate settingsViewController:self didChangePrice:self.priceTextField.text];
    }
    else  {
        
        GlobalSettings *globalSettings = [GlobalSettings sharedManager];
        self.priceTextField.text = globalSettings.cookiePrice;

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Price" message:@"The price you entered is not a valid price. Please enter one." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
    }

}

- (IBAction)cancel:(id)sender {
    [self.delegate settingsViewControllerDidCancel:self];
}

@end
