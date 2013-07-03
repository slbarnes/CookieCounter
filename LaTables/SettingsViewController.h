//
//  SettingsViewController.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidCancel: (SettingsViewController *)controller;

@end

@interface SettingsViewController : UITableViewController<MFMailComposeViewControllerDelegate> {
    
}

@property (nonatomic, assign) BOOL priceChanged;
@property (nonatomic, assign) BOOL cookieTypesChanged;


@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)textFieldFinished:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;
@end
