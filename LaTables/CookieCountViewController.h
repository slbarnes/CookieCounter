//
//  CookieCountViewController.h
//  LaTables
//
//  Created by Shelley Barnes on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CookieCountViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>  {
    NSDecimalNumber *totalNumberOfCookies;
    NSDecimalNumber *totalMonies;
}
@property(nonatomic, retain)NSMutableArray *cookiesAllInfo;
@property(nonatomic, retain)NSString *listName;

- (IBAction)stepperChangeValue:(UIStepper *)sender;
- (IBAction)sendEmailFromCookieCount;
@end
