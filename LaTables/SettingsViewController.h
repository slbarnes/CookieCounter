//
//  SettingsViewController.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidSave:(SettingsViewController *)controller;
- (void) settingsViewCOntrollerDidCancel: (SettingsViewController *)controller;

@end

@interface SettingsViewController : UITableViewController

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
