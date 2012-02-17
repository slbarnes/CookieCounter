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
@property (nonatomic, strong) NSMutableArray *cookieLists;

// Will store the cookie names and their price that is showed in the counting list.
// Key : cookie list     value : price
@property(nonatomic, retain)NSMutableDictionary *cookieNamesAndPrice;
@property(nonatomic, retain)NSMutableDictionary *allTheData;

-(void)setupArray;
-(void)setupCookieNames;

- (IBAction)sendEmailFromMain;

@end
