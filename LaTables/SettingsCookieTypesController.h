//
//  SettingsCookieTypesController.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCookieTypeViewController.h"

@interface SettingsCookieTypesController : UITableViewController <AddCookieTypeViewControllerDelegate> {
    NSMutableArray *cookieTypes;
}

@end
