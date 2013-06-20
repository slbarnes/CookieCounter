//
//  CookieCountViewController.h
//  LaTables
//
//  Created by Shelley Barnes on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "CookieListNotesViewController.h"

@interface CookieCountViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate, CookieListNotesViewControllerDelegate>  {
    NSDecimalNumber *totalNumberOfCookies;
    NSDecimalNumber *totalMonies;
    NSDecimalNumber *donationAmount;
}

@property(nonatomic, retain)NSIndexPath *selectIndexPath;


- (IBAction)stepperChangeValue:(UIStepper *)sender;
- (IBAction)sendEmailFromCookieCount;
- (IBAction)textFieldFinished:(id)sender;

@end
