//
//  Constants.m
//  CookieCounter
//
//  Created by Shelley Barnes on 6/27/13.
//
//

#import "Constants.h"

// Helpful Tip Alert Box
NSString *const HelpfulTipTitle = @"Helpful Tip";
NSString *const HelpfulTipMessage = @"Be sure to set the price and cookie types for your area by clicking the gear on the bottom right.";
NSString *const HelpfulTipCancelButtonTitle = @"OK";

NSString *const CookieCountViewControllerIdentifier = @"cookieCountTable";

// Error with new list name Alert Box
NSString *const NewListNameErrorTitle = @"Error";
NSString *const NewListNameErrorMessage = @"Duplicate list names are not allowed.";
NSString *const NewListNameErrorCancelButtonTitle = @"OK";

// Error with new list name only spaces
NSString *const NewListNameSpacesErrorTitle = @"Invalid Name";
NSString *const NewListNameSpacesErrorMessage = @"A list name must have one alphanumeric character.";
NSString *const NewListNameSpacesErrorCancelButtonTitle = @"OK";

// Error with price
NSString *const PriceErrorTitle = @"Invalid Price";
NSString *const PriceErrorMessage = @"The price you entered is not a valid price. It must be in the format of d.cc";
NSString *const PriceErrorCancelButtonTitle = @"OK";

NSString *const CookieListDetailsViewSegueIdentifier = @"AddPlayer";

NSString *const SettingsViewSegueIdentifier = @"EditSettings";

NSString *const AllSummaryEmailSubject = @"All Cookie Lists Detail Report\n\n";

// ApplyChanges array values
NSInteger const ApplyChangesAllListsIndexValue = 0;
NSInteger const ApplyChangesNewListsIndexValue = 1;

NSString *const STARTING_QTY = @"0";

NSString *const DefaultNotesText=@"\nName: \nAddress: \nTelephone: \n\nEnter notes about the list here.";

NSString *const PaidIcon = @"\U0001F4B5";
NSString *const DeliveredIcon = @"\U0001F4E6";
NSString *const PaidAndDeliveredIcon =  @"\U0001F4B5 \U0001F4E6";

NSString *const PaidLabel = @"\U0001F4B5  Paid";
NSString *const DeliveredLabel = @"\U0001F4E6  Delivered";



