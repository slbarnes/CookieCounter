//
//  SettingsViewController.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "GlobalSettings.h"
#import "AppData.h"
#import "Constants.h"
#import "SettingsCookieTypesController.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize priceTextField;
@synthesize segmentedControl;
@synthesize priceChanged;
@synthesize cookieTypesChanged;

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
    NSLog(@"[DEBUG] SettingsViewController:viewDidLoad");
    //NSLog(@"[DEBUG] SettingsViewController:viewDidLoad : priceChanged %d cookieTypesChanged %d",self.priceChanged, self.cookieTypesChanged);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    self.priceTextField.text = globalSettings.cookiePrice;
    [self.priceTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //NSLog(@"[DEBUG] SettingsViewController:viewDidLoad applySettings : %i",globalSettings.applySettings);
    self.segmentedControl.selectedSegmentIndex = globalSettings.applySettings;
    //self.priceChanged = NO;
    //self.cookieTypesChanged = NO;

}

// This method is called when Done is tapped for the keyboard when editing the text field
- (IBAction)textFieldFinished:(id)sender  {
    
    //NSLog(@"[DEBUG] SettingsViewController:textFieldFinished");
    [self verifyPriceTextField];
    
    
    
    [sender resignFirstResponder];
}

- (BOOL)verifyPriceTextField  {
    
    NSString *regex = @"^\\d+\\.\\d\\d";
    NSPredicate *valtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL ret = [valtest evaluateWithObject:self.priceTextField.text];
    NSDecimalNumber *topPrice = [NSDecimalNumber decimalNumberWithString:@"999.00"];
    NSDecimalNumber *theEnteredPrice = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];

    if ((!ret) || ([theEnteredPrice compare:topPrice] == NSOrderedDescending) || (self.priceTextField.text == nil) ) {
        GlobalSettings *globalSettings = [GlobalSettings sharedManager];
        self.priceTextField.text = globalSettings.cookiePrice;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:PriceErrorTitle message:PriceErrorMessage delegate:nil cancelButtonTitle:PriceErrorCancelButtonTitle otherButtonTitles:nil];
        [message show];

        return NO;
    }
    
    return YES;
}

// This method is called when the done is tapped in the top right of the menu bar
- (IBAction)done:(id)sender  {
    //NSLog(@"[DEBUG} SettingsViewController:done");
    NSLog(@"[DEBUG] SettingsViewController:done : priceChanged %d cookieTypesChanged %d",self.priceChanged, self.cookieTypesChanged);

    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    AppData *sharedAppData = [AppData sharedData];

    if ([self verifyPriceTextField])  {
        NSLog(@"[DEBUG] SettingsViewController:done : globalSettings.cookiePrice %@ self.priceTextField.text %@",globalSettings.cookiePrice, self.priceTextField.text);
        if (![globalSettings.cookiePrice isEqualToString:self.priceTextField.text] ) {
            
            self.priceChanged = YES;
            globalSettings.cookiePrice = self.priceTextField.text;
            [sharedAppData writeDataToFile];
        }

        // Since the price is good, then verify apply settings
        // 1.  If apply settings was changed from New to All, then verify to continue with an alert
   
        NSInteger currentSelection = [self.segmentedControl selectedSegmentIndex];
        if ( (globalSettings.applySettings == ApplyChangesNewListsIndexValue) &&
            (currentSelection == ApplyChangesAllListsIndexValue) )  {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have selected All Cookie Sales Lists to be updated with changes to price and cookie types.  Any existing lists will now be updated. This may include removing cookies that were removed from Cookie Types.  Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            [message show];

        
        }
        else  {
            if (currentSelection == ApplyChangesAllListsIndexValue) {
                if (self.priceChanged) {
                    [self updateDataWithNewPrice];
                }
                if (self.cookieTypesChanged) {
                    [self updateDataWithNewCookieTypes];
                }
            }
                globalSettings.applySettings = currentSelection;
                [sharedAppData writeDataToFile];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else  {
        // The Done button on the title bar was clicked, price is invalid, so need to dismiss the keyboard
        [priceTextField resignFirstResponder];

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    NSLog(@"[DEBUG] SettingsViewController:alertView : priceChanged %d cookieTypesChanged %d",self.priceChanged, self.cookieTypesChanged);
    
    if (buttonIndex == 0) {
        NSLog(@"[DEBUG] SettingsViewController:alertView : Cancel button clicked");
        self.segmentedControl.selectedSegmentIndex = ApplyChangesNewListsIndexValue;
    }
    else  {
        NSLog(@"[DEBUG] SettingsViewController:alertView : OK button clicked");
        if (self.priceChanged) {
            [self updateDataWithNewPrice];
        }
        if (self.cookieTypesChanged) {
            [self updateDataWithNewCookieTypes];
        }
        GlobalSettings *globalSettings = [GlobalSettings sharedManager];
        AppData *sharedAppData = [AppData sharedData];
        globalSettings.applySettings = ApplyChangesAllListsIndexValue;
        [sharedAppData writeDataToFile];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}


-(void)updateDataWithNewPrice  {
    //NSLog(@"[DEBUG] ***SettingsViewController:updateDataWithNewPrice***");
    AppData *sharedAppData = [AppData sharedData];
    [sharedAppData updateAllWithPrice:self.priceTextField.text];

    
}

-(void)updateDataWithNewCookieTypes  {
    //NSLog(@"[DEBUG] ***SettingsViewController:updateDataWithNewCookieTypes***");
    AppData *sharedAppData = [AppData sharedData];
    [sharedAppData updateAllWithCookieTypes];

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
    //NSLog(@"[DEBUG] SettingsViewController:viewWillDisappear");
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
        //NSLog(@"HERE");
        [self.priceTextField becomeFirstResponder];
    }
    if (indexPath.section == 2)  {
        //NSLog(@"HERE 2");
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
    if (indexPath.section == 3) {
        //NSLog(@"HERE 3");

        [self.segmentedControl becomeFirstResponder];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
    [self.delegate settingsViewControllerDidCancel:self];
}

- (IBAction)segmentedControlChanged:(id)sender {
    //GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    //globalSettings.applySettings = [self.segmentedControl selectedSegmentIndex];
    
    // TODO : When do I update other lists based on changes???  When done is hit?  When the segment is changed?
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditCookieTypes"])
    {
        //NSLog(@"SettingsViewController:prepareForSegue EditCookieTypes 1");
        //UINavigationController *navigationController = segue.destinationViewController;
        //NSLog(@"SettingsViewController:prepareForSegue EditCookieTypes 2");

        //SettingsCookieTypesController *settingsCookieTypesViewController = [[navigationController viewControllers]objectAtIndex:0];
        //NSLog(@"SettingsViewController:prepareForSegue EditCookieTypes 3");

        SettingsCookieTypesController *settingsCookieTypesViewController = segue.destinationViewController;
        settingsCookieTypesViewController.settingsViewController = self;
        //NSLog(@"SettingsViewController:prepareForSegue EditCookieTypes 4");

    }
    
    
}

@end
