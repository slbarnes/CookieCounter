//
//  MainTableViewController.h
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CookieListDetailsViewController.h"
#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, CookieListDetailsViewControllerDelegate, SettingsViewControllerDelegate, MFMailComposeViewControllerDelegate>  {
    
}

- (void) updateListName:(NSString *)newName atIndex:(int)index;

- (IBAction)sendEmailFromMain;

@end