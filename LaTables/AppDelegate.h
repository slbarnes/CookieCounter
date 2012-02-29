//
//  AppDelegate.h
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"
#import "GlobalSettings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>  {
    IBOutlet MainTableViewController *mainController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet MainTableViewController *mainController;

-(void)writeData;
-(void)readData;
@end
