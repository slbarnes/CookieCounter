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
- (void)addCookieTypeViewController:(AddCookieTypeViewController *)controller didAddCookieType:(NSString   *)cookieType;


@end

@interface AddCookieTypeViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *cookieTypeToAdd;

@property (nonatomic, weak) id <AddCookieTypeViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
