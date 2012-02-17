//
//  CookieListDetailsViewController.h
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CookieListName.h"

@class CookieListDetailsViewController;

@protocol CookieListDetailsViewControllerDelegate <NSObject>

- (void)cookieListDetailsViewControllerDidCancel: (CookieListDetailsViewController *)controller;
- (void)cookieListDetailsViewController:(CookieListDetailsViewController *)controller didAddCookieList:(CookieListName *)cookieListName;

@end

@interface CookieListDetailsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, weak) id <CookieListDetailsViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
