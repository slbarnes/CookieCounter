//
//  AppDelegate.m
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GSCookie.h"
#import "CookieCountViewController.h"
#import "MainTableViewController.h"
#import "GlobalSettings.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@"Here in AppDelegate:didFinishLaunchingWithOptions");
    //[self readData];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    NSLog(@"Here in AppDelegate:applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    NSLog(@"Here in AppDelegate:applicationDidEnterBackground");
    [self writeData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Here in AppDelegate:applicationWillEnterForeground");
    [self readData];

    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSLog(@"Here in AppDelegate:applicationDidBecomeActive");

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    NSLog(@"Here in AppDelegate:applicationWillTerminate");

}


- (void)readData
{
    // 1. Check to see if allthedata.plist exists.  If not, then load from ExampleData.plist
    
    // How To Load
    // 1. Suck in the data into a dictionary
    // 2. Now need to transform this dictionary into allTheData object
    //      Dictionary key-Top Level List Name     value-array of GSCookie objects
    //
    // Transformation
    // Get all the keys
    // For each key build an array of GSCookie objects
    //      For each key
    //          Create a GSCookie object (key is name)
    //          Add to array
    //      Add array for list name key
    NSLog(@"Here reading data");
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"allthedata.plist"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Using ExampleData");
        path = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"plist"];
    }
    
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
    //NSLog(@"Data from file: %@",plistData);
    
    NSArray *keysOfPlistData = [plistData allKeys];
    
    mainController.allTheData = [[NSMutableDictionary alloc] init];

    NSMutableArray *unsortedCookieLists = [[NSMutableArray alloc] init];
    for (NSString *key in keysOfPlistData)  {
        NSMutableDictionary *dictOfGSCookieObjects = [plistData objectForKey:key];

        if ([key isEqualToString:@"SowSoftwareSettings"]) {
                //NSLog(@"Found SowSoftwareSettings");
                globalSettings.cookiePrice = [dictOfGSCookieObjects objectForKey:@"GlobalPrice"];
                globalSettings.cookieTypes = [dictOfGSCookieObjects objectForKey:@"GlobalCookieTypes"];
                continue;
            }
        NSMutableArray *arrayOfGSCookieObjects = [[NSMutableArray alloc] init];
                
        NSArray *keysOfDictOfGSCookieObjects = [[dictOfGSCookieObjects allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        

        CookieListName *cookieListName = [[CookieListName alloc] init];
        cookieListName.name = key;

        for (NSString *keyGSCookie in keysOfDictOfGSCookieObjects)  {
            if ([keyGSCookie isEqualToString:@"SowSoftwareProperties"]) {
                cookieListName.sowSoftwareListOrder = [[dictOfGSCookieObjects objectForKey:keyGSCookie]objectForKey:@"Order"];
                //NSLog(@"Found list order tag: %@", cookieListName.sowSoftwareListOrder);
                cookieListName.sowSoftwareListNotes = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"ListNotes"];
                NSLog(@"Found list notes tag: %@", cookieListName.sowSoftwareListNotes);
                continue;
            }
            GSCookie *newGSCookie = [[GSCookie alloc] init];
            newGSCookie.name = keyGSCookie;
            NSString *squantity = [[dictOfGSCookieObjects objectForKey:keyGSCookie]objectForKey:@"Quantity"];
            newGSCookie.quantity = [[NSDecimalNumber alloc] initWithString:squantity];
            NSString *sprice = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Price"];
            newGSCookie.price = [[NSDecimalNumber alloc] initWithString:sprice];
            
            [arrayOfGSCookieObjects addObject:newGSCookie];
            //NSLog(@"cookie name: %@   cookie quantity: %@     cookie price: %@",newGSCookie.name, squantity, sprice);

        }
        //NSLog(@"List name: %@", key);
        [mainController.allTheData setObject:arrayOfGSCookieObjects forKey:key];
        [unsortedCookieLists addObject:cookieListName];
    }
    
    // Now sort mainController.cookieLists
    //NSLog (@"unsortedCookieList count: %d",[unsortedCookieLists count]);
    mainController.cookieLists = [[NSMutableArray alloc] init];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sowSoftwareListOrder" ascending:YES];

    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    mainController.cookieLists = [NSMutableArray arrayWithArray:[unsortedCookieLists sortedArrayUsingDescriptors:sortDescriptors]];

    //NSLog(@"readData:mainController.cookieLists count: %d",[mainController.cookieLists count]);
    //NSLog (@"unsortedCookieList count: %d",[unsortedCookieLists count]);



}
- (void)writeData
{
    NSLog(@"Here writing data");
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"allthedata.plist"];
    //NSLog(@"path: %@",path);
    
    // Need to take the data structure and put it into a format that can write to a plist.
    // This is going to be ugly.....
    // Should this be in the GSCookie object as well as the MainTableViewController object to convert to dictionaries?  i.e like the toString method in java...
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // Write out the settings
    //globalSettings = [GlobalSettings sharedManager];

    NSMutableDictionary *sowSoftwareSettingsDict = [[NSMutableDictionary alloc] init];
    [sowSoftwareSettingsDict setObject:globalSettings.cookiePrice forKey:@"GlobalPrice"];
    [sowSoftwareSettingsDict setObject:globalSettings.cookieTypes forKey:@"GlobalCookieTypes"];
    [dict setObject:sowSoftwareSettingsDict forKey:@"SowSoftwareSettings"];

    // Write out the cookie lists
    // 1. Iterate over all the keys
    // Foreach key in mainController.allTheData
    //  1. Get the GSCookie Object
    //  2. Create a dictionary with keys of quantity and price
    //  3. Create a dictionary with the key being the name of the GSCookie object and the value being the dictionary just created in step 2
    //  4. Create a entry in dict with the key being the listname (ie the key in the foreach loop) and the value being the dictionary just created in step 3
    
    NSArray *keysOfAllTheData = [mainController.allTheData allKeys];
    //NSLog(@"Count of keysOfAllTheData: %d",[keysOfAllTheData count]);
    for (NSString *key in keysOfAllTheData)  {
        
        NSMutableArray *arrayOfGSCookies = [mainController.allTheData objectForKey:key];
        NSMutableDictionary *dictionaryOfGSCookies = [[NSMutableDictionary alloc] init];
        
        for (GSCookie *gsCookie in arrayOfGSCookies) {

            NSMutableDictionary *cookieValues = [[NSMutableDictionary alloc] init];
            [cookieValues setObject:[gsCookie.quantity stringValue] forKey:@"Quantity"];
            [cookieValues setObject:[gsCookie.price stringValue] forKey:@"Price"];
            [dictionaryOfGSCookies setObject:cookieValues forKey:gsCookie.name];
            
        }
        
        // Now that we have the cookie dictionary object, need to add the SowSoftwareListOrder
        // dictionarry object so we know what order to load the lists the next time
        for (CookieListName *cookieListName in mainController.cookieLists)  {
            if ([cookieListName.name isEqualToString:key]) {
                NSMutableDictionary *sowSoftwareListOrder = [[NSMutableDictionary alloc] init];
                [sowSoftwareListOrder setObject:cookieListName.sowSoftwareListOrder forKey:@"Order"];
                [dictionaryOfGSCookies setObject:sowSoftwareListOrder  forKey:@"SowSoftwareProperties"];
                //NSLog(@"cookieListName: %@  key: %@",cookieListName.name,key);

                break;
            }
        }
        [dict setObject:dictionaryOfGSCookies forKey:key];
        
    }
    
    //NSLog(@"%@",dict);
    [dict writeToFile:path atomically:YES];

}
@end
