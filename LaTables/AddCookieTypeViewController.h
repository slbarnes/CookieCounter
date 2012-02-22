//
//  AddCookieTypeViewController.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class AddCookieTypeViewController;

@protocol AddCookieTypeViewControllerDelegate <NSObject>

- (void)addCookieTypeViewControllerDidCancel:(AddCookieTypeViewController *)controller;
- (void)addCookieTypeViewControllerDidSave:(AddCookieTypeViewController *)controller;

@end

@interface AddCookieTypeViewController : UITableViewController

@property (nonatomic, weak) id <AddCookieTypeViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
