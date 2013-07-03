//
//  SettingsCookieTypesController.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCookieTypeViewController.h"
#import "GlobalSettings.h"
#import "SettingsViewController.h"

@interface SettingsCookieTypesController : UITableViewController <AddCookieTypeViewControllerDelegate> {
    GlobalSettings *globalSettings;
}

// Need a pointer back to the settings view controller so I can set the flag for cookie types changing.  Since BOOL isn't a pointer, not sure how to get the parent instance and set it correctly.
// TODO: Experiment with this being a BOOL.  DOn't think it will work since not a pointer.
@property(nonatomic, retain)SettingsViewController *settingsViewController;

@end
