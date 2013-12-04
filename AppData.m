//
//  AppData.m
//  CookieCounter
//
//  Created by Shelley Barnes on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "CookieListName.h"
#import "GSCookie.h"
#import "GlobalSettings.h"
#import "Constants.h"

static AppData *sharedMyAppData = nil;

@implementation AppData

@synthesize allTheData; // Need to make these private
@synthesize cookieLists; // Need to make these private

+ (id)sharedData  {
    @synchronized(self)  {
        if (sharedMyAppData == nil) {
            sharedMyAppData = [[self alloc] init];
        }
    }
    return sharedMyAppData;
}

- (void)setLoadedDataFromExampleList:(BOOL)yesorno  {
    loadedDataFromExampleList = yesorno;
}
- (BOOL)getLoadedDataFromExampleList  {
    return loadedDataFromExampleList;
}

- (id)init  {
    if (self = [super init]) {
        // Do something here for initialization
        allTheData = [[NSMutableDictionary alloc] init];
        cookieLists = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readDataFromFile  {
    // Should read data from the file and put in allTheData
    
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
    //NSLog(@"[DEBUG] AppData:readDataFromFile Reading Data");
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    AppData *sharedAppData = [AppData sharedData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"allthedata.plist"];
    loadedDataFromExampleList = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //NSLog(@"[DEBUG] AppData:readDataFromFile Using ExampleData");
        path = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"plist"];
        loadedDataFromExampleList = YES;
    }
    
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
    //NSLog(@"Data from file: %@",plistData);
    
    NSArray *keysOfPlistData = [plistData allKeys];
    
    sharedAppData.allTheData = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *unsortedCookieLists = [[NSMutableArray alloc] init];
    for (NSString *key in keysOfPlistData)  {
        NSMutableDictionary *dictOfGSCookieObjects = [plistData objectForKey:key];
        
        if ([key isEqualToString:@"SowSoftwareSettings"]) {
            //NSLog(@"[DEBUG] AppData:readDataFromFile : Found SowSoftwareSettings");
            globalSettings.cookiePrice = [dictOfGSCookieObjects objectForKey:@"GlobalPrice"];
            globalSettings.cookieTypes = [dictOfGSCookieObjects objectForKey:@"GlobalCookieTypes"];
            globalSettings.applySettings = [[dictOfGSCookieObjects objectForKey:@"GlobalApplySettings"] integerValue];
            continue;
        }
        NSMutableArray *arrayOfGSCookieObjects = [[NSMutableArray alloc] init];
        
        NSArray *keysOfDictOfGSCookieObjects = [[dictOfGSCookieObjects allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        
        CookieListName *cookieListName = [[CookieListName alloc] init];
        cookieListName.name = key;
        
        for (NSString *keyGSCookie in keysOfDictOfGSCookieObjects)  {
            if ([keyGSCookie isEqualToString:@"SowSoftwareProperties"]) {
                cookieListName.sowSoftwareListOrder = [[dictOfGSCookieObjects objectForKey:keyGSCookie]objectForKey:@"Order"];
                cookieListName.sowSoftwareListNotes = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"ListNotes"];
                
                if ([[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Donation"]) {
                    cookieListName.donation = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Donation"];
                }
                else {
                    cookieListName.donation = @"0.00";
                }
                
                if ([[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Paid"]) {
                    cookieListName.paid = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Paid"];
                } else {
                    cookieListName.paid = @"0";
                }
                
                if ([[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Delivered"]) {
                    cookieListName.delivered = [[dictOfGSCookieObjects objectForKey:keyGSCookie] objectForKey:@"Delivered"];
                } else {
                    cookieListName.delivered = @"0";
                }
                
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
        [sharedAppData.allTheData setObject:arrayOfGSCookieObjects forKey:key];
        [unsortedCookieLists addObject:cookieListName];
    }
    
    // Now sort mainController.cookieLists
    //NSLog (@"unsortedCookieList count: %d",[unsortedCookieLists count]);
    sharedAppData.cookieLists = [[NSMutableArray alloc] init];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sowSoftwareListOrder" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    //NSLog(@"[DEBUG] before is cookeLists empty: %i",sharedAppData.cookieLists.count);
    sharedAppData.cookieLists = [NSMutableArray arrayWithArray:[unsortedCookieLists sortedArrayUsingDescriptors:sortDescriptors]];
    //NSLog(@"[DEBUG] after is cookeLists empty: %i",sharedAppData.cookieLists.count);

    //NSLog(@"readData:mainController.cookieLists count: %d",[mainController.cookieLists count]);
    //NSLog (@"unsortedCookieList count: %d",[unsortedCookieLists count]);

}

- (void)writeDataToFile  {
    //Should write data from allTheData to a file
    NSLog(@"[DEBUG] AppData:writeDataToFile Here writing data");
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    AppData *sharedAppData = [AppData sharedData];
    
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
    [sowSoftwareSettingsDict setObject:[NSNumber numberWithInteger:globalSettings.applySettings] forKey:@"GlobalApplySettings"];
    [dict setObject:sowSoftwareSettingsDict forKey:@"SowSoftwareSettings"];
    
    // Write out the cookie lists
    // 1. Iterate over all the keys
    // Foreach key in mainController.allTheData
    //  1. Get the GSCookie Object
    //  2. Create a dictionary with keys of quantity and price
    //  3. Create a dictionary with the key being the name of the GSCookie object and the value being the dictionary just created in step 2
    //  4. Create a entry in dict with the key being the listname (ie the key in the foreach loop) and the value being the dictionary just created in step 3
    
    NSArray *keysOfAllTheData = [sharedAppData.allTheData allKeys];
    //NSLog(@"Count of keysOfAllTheData: %d",[keysOfAllTheData count]);
    for (NSString *key in keysOfAllTheData)  {
        
        NSMutableArray *arrayOfGSCookies = [sharedAppData.allTheData objectForKey:key];
        NSMutableDictionary *dictionaryOfGSCookies = [[NSMutableDictionary alloc] init];
        
        for (GSCookie *gsCookie in arrayOfGSCookies) {
            
            NSMutableDictionary *cookieValues = [[NSMutableDictionary alloc] init];
            [cookieValues setObject:[gsCookie.quantity stringValue] forKey:@"Quantity"];
            [cookieValues setObject:[gsCookie.price stringValue] forKey:@"Price"];
            [dictionaryOfGSCookies setObject:cookieValues forKey:gsCookie.name];
            
        }
        
        // Now that we have the cookie dictionary object, need to add the SowSoftwareListOrder
        // dictionarry object so we know what order to load the lists the next time
        for (CookieListName *cookieListName in sharedAppData.cookieLists)  {
            if ([cookieListName.name isEqualToString:key]) {
                //NSLog(@"donation %@  paid  %@   delivered  %@", cookieListName.donation,cookieListName.paid,cookieListName.delivered);
                NSMutableDictionary *sowSoftwareListOrder = [[NSMutableDictionary alloc] init];
                [sowSoftwareListOrder setObject:cookieListName.sowSoftwareListOrder forKey:@"Order"];
                [sowSoftwareListOrder setObject:cookieListName.sowSoftwareListNotes forKey:@"ListNotes"];
                [sowSoftwareListOrder setObject:cookieListName.donation forKey:@"Donation"];
                [sowSoftwareListOrder setObject:cookieListName.paid forKey:@"Paid"];
                [sowSoftwareListOrder setObject:cookieListName.delivered forKey:@"Delivered"];
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

- (void)setListNotes:(NSUInteger)listIndex :(NSString *)theNote  {
    CookieListName *c = [self.cookieLists objectAtIndex:listIndex];
    c.sowSoftwareListNotes = theNote;
    // Should need to replace the object in the array with c....
}

- (NSString *)getListNotes:(NSUInteger)listIndex  {
    return ([[self.cookieLists objectAtIndex:listIndex] sowSoftwareListNotes] );
}

- (void)setDonation:(NSString *)donation forIndex:(NSUInteger)listIndex {
    CookieListName *c = [self.cookieLists objectAtIndex:listIndex];
    c.donation = donation;
    // Should need to replace the object in the array with c....
}

- (NSString *)getDonation:(NSUInteger)listIndex  {
    return ([[self.cookieLists objectAtIndex:listIndex] donation] );
}

- (void)setPaid:(NSString *)paid forIndex:(NSUInteger)listIndex {
    CookieListName *c = [self.cookieLists objectAtIndex:listIndex];
    c.paid = paid;
    // Should need to replace the object in the array with c....
}

- (NSString *)getPaid:(NSUInteger)listIndex  {
    return ([[self.cookieLists objectAtIndex:listIndex] paid] );
}

- (void)setDelivered:(NSString *)delivered forIndex:(NSUInteger)listIndex {
    CookieListName *c = [self.cookieLists objectAtIndex:listIndex];
    c.delivered = delivered;
    // Should need to replace the object in the array with c....
}

- (NSString *)getDelivered:(NSUInteger)listIndex  {
    return ([[self.cookieLists objectAtIndex:listIndex] delivered] );
}

- (void)updateListName:(NSUInteger)listIndex withName:(NSString *)name {
    CookieListName *c = [self.cookieLists objectAtIndex:listIndex];
    NSLog(@"[DEBUG] AppData:setListName old name: %@  new name: %@ index: %lu",c.name, name, (unsigned long)listIndex);
    [self replaceKey:c.name withKey:name inMutableDictionary:self.allTheData];
    c.name = name;
}

- (NSString *)getListName:(NSUInteger)listIndex  {
    return ([[self.cookieLists objectAtIndex:listIndex] name]);
}

- (void)removeCookieList:(NSUInteger)listIndex  {
    
    [self.allTheData removeObjectForKey:[self getListName:listIndex]];
    [self.cookieLists removeObjectAtIndex:listIndex];
    
}

- (NSUInteger)getNumberOfCookieLists  {
    return ([self.cookieLists count]);
}

- (void)setSowSoftwareListOrder:(NSUInteger)listIndex order:(NSUInteger)order  {
    CookieListName *cookieListName = [self.cookieLists objectAtIndex:listIndex];
    cookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",order];
}

- (BOOL)doesCookieListNameExist:(NSString *)name  {
    if ([self.allTheData objectForKey:name] == nil) {
        return (NO);
    }
    
    return (YES);
}

- (void)addNewCookieList:(NSString *)name  {
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    
    NSArray *sortedKeys = [globalSettings.cookieTypes sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];  
    NSMutableArray *initialCookieInfo = [NSMutableArray arrayWithCapacity:[sortedKeys count]];
    
    
    
    for (NSString *key in sortedKeys)  {
        GSCookie *gscookie;
        gscookie = [[GSCookie alloc] init];
        gscookie.name = key;
        gscookie.price = [[NSDecimalNumber alloc] initWithString:globalSettings.cookiePrice];
        gscookie.quantity = [[NSDecimalNumber alloc] initWithString:STARTING_QTY];
        [initialCookieInfo addObject:gscookie];
    }
    
    CookieListName *cookieListName = [[CookieListName alloc] init];
    cookieListName.name = name;
    // Need to determine the value for sowsoftwareListOrder
    cookieListName.sowSoftwareListOrder = [NSString stringWithFormat:@"%d",[self.cookieLists count]];
    cookieListName.sowSoftwareListNotes = DefaultNotesText;
    cookieListName.donation = @"";
    cookieListName.paid = @"0";
    cookieListName.delivered = @"0";
    NSLog(@"[DEBUG] cookieListName: %@   sowsoftwareListOrder: %@", cookieListName.name, cookieListName.sowSoftwareListOrder);
    [self.cookieLists addObject:cookieListName];
    [self.allTheData setObject:initialCookieInfo forKey:cookieListName.name];

}

- (NSString *)createAllListSummary  {
    
    NSMutableString *messageBody = [NSMutableString stringWithString:@"<b>All Cookie Lists Detail Report</b>"];
    [messageBody appendString:@"<br><br><hr><br>"];

    NSDecimalNumber *grandTotalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *grandTotalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    NSMutableDictionary *grandTotalEachType = [[NSMutableDictionary alloc] init];
    
    NSMutableString *eachList = [NSMutableString stringWithString:@""];
    
    for (CookieListName *cookieListName in self.cookieLists) {
        
        NSDecimalNumber *totalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
        NSDecimalNumber *totalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];

        [eachList appendFormat:@"<b>Name:</b> %@<br><br>",cookieListName.name];
        
        for (GSCookie *gscookie in [self.allTheData objectForKey:cookieListName.name])
        {
            if ([gscookie.quantity compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {
            
                NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
                [eachList appendFormat:@"<b>%@</b>: %@ @ $%.2f = $%.2f<br>",gscookie.name, gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
                totalNumberOfCookies = [totalNumberOfCookies decimalNumberByAdding:gscookie.quantity];
                totalMonies = [totalNumberOfCookies decimalNumberByMultiplyingBy:gscookie.price];
            
                // Check if the cookie name is in grandTotalEachType.  If not, set the quantity.  If so, add the quantity
                if ([grandTotalEachType objectForKey:gscookie.name]) {
                    NSDecimalNumber *t = [grandTotalEachType objectForKey:gscookie.name];
                    //NSLog(@"Cookie name exists: %@  with quantity %@",gscookie.name,t);
                
                    t = [t decimalNumberByAdding:gscookie.quantity];
                    [grandTotalEachType setObject:t forKey:gscookie.name];
                }
                else  {
                    [grandTotalEachType setObject:gscookie.quantity forKey:gscookie.name];
                }
            }
            
        }
        [eachList appendFormat:@"<br><b>Total Cookies</b>: %@ <br>", totalNumberOfCookies];
        [eachList appendFormat:@"<b>Total Monies</b>: $%.2f <br><br>", [totalMonies floatValue]];
        
        if ([cookieListName.donation length] < 1) {
            [eachList appendFormat:@"<br><b>Donation</b>: $0.00<br>"];
        }
        else  {
            [eachList appendFormat:@"<b>Donation</b>: $%@<br>",cookieListName.donation];
        }
        if ([cookieListName.paid isEqualToString:@"0"]) {
            [eachList appendFormat:@"<b>Paid</b>: No<br>"];
        }
        else  {
            [eachList appendFormat:@"<b>Paid</b>: Yes<br>"];
        }
        if ([cookieListName.delivered isEqualToString:@"0"]) {
            [eachList appendFormat:@"<b>Delivered</b>: No<br>"];
        }
        else  {
            [eachList appendFormat:@"<b>Delivered</b>: Yes<br>"];
        }

        [eachList appendFormat:@"<br><b>Notes</b>:<br><pre>%@</pre><br>",cookieListName.sowSoftwareListNotes];

        [eachList appendString:@"<br><hr><br>"];
        
        grandTotalNumberOfCookies = [grandTotalNumberOfCookies decimalNumberByAdding:totalNumberOfCookies];
        grandTotalMonies = [grandTotalMonies decimalNumberByAdding:totalMonies];
        
        
    }
    
    [messageBody appendString:@"<b>G R A N D &nbsp;&nbsp; T O T A L S</b><br><br>"];

    [messageBody appendFormat:@"<b>Grand Total Cookies</b>: %@ <br>", grandTotalNumberOfCookies];
    [messageBody appendFormat:@"<b>Grand Total Monies</b>: $%.2f <br><br>", [grandTotalMonies floatValue]];
        
    [messageBody appendFormat:@"<b>Grand Total For Each Cookie Type</b><br>"];
    NSArray *keys = [[grandTotalEachType allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString *key in keys)  {
        [messageBody appendFormat:@"<b>%@</b> : %@<br>",key,[grandTotalEachType objectForKey:key]];
    }
    
    [messageBody appendString:@"<br><br><hr><br><br>"];
    [messageBody appendString:eachList];
    
    return (messageBody);
    
}

- (NSString *)createSummaryForOneList:(CookieListName *)cookieListName  { 
            
    NSMutableString *messageBody = [NSMutableString stringWithFormat:@"<b><u>%@</u></b><br>Detail Report<br><br>",cookieListName.name];
    
    NSMutableArray *allCookies = [self.allTheData objectForKey:cookieListName.name];

    // Calculate totals
    NSDecimalNumber *totalMonies = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *totalNumberOfCookies = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (GSCookie *gscookie in allCookies) {
        totalNumberOfCookies = [totalNumberOfCookies decimalNumberByAdding:gscookie.quantity];
        totalMonies = [totalNumberOfCookies decimalNumberByMultiplyingBy:gscookie.price];
    }
        
    [messageBody appendFormat:@"<b>Total Cookies</b>: %@ <br>", totalNumberOfCookies];
    [messageBody appendFormat:@"<b>Total Monies</b>: $%.2f <br><br>", [totalMonies floatValue]];
    
    
    for (GSCookie *gscookie in allCookies)
    {
        if ([gscookie.quantity compare:[NSNumber numberWithInt:0]] == NSOrderedDescending) {

            NSDecimalNumber *total = [gscookie.quantity decimalNumberByMultiplyingBy:gscookie.price];
            [messageBody appendFormat:@"<b>%@</b>: %@ @ $%.2f = $%.2f<br>",gscookie.name, gscookie.quantity, [gscookie.price floatValue], [total floatValue]];
        }
    }
    
    if ([cookieListName.donation length] < 1) {
        [messageBody appendFormat:@"<br><b>Donation</b>: $0.00<br>"];
    }
    else  {
        [messageBody appendFormat:@"<br><b>Donation</b>: $%@<br>",cookieListName.donation];
    }
    if ([cookieListName.paid isEqualToString:@"0"]) {
        [messageBody appendFormat:@"<b>Paid</b>: No<br>"];
    }
    else  {
        [messageBody appendFormat:@"<b>Paid</b>: Yes<br>"];
    }
    if ([cookieListName.delivered isEqualToString:@"0"]) {
        [messageBody appendFormat:@"<b>Delivered</b>: No<br>"];
    }
    else  {
        [messageBody appendFormat:@"<b>Delivered</b>: Yes<br>"];
    }


    [messageBody appendFormat:@"<br><b>Notes</b>:<br><pre>%@</pre><br>",cookieListName.sowSoftwareListNotes];

    return (messageBody);
}

- (NSUInteger)getNumberOfCookiesForList:(NSUInteger)listIndex  {

    return [[self.allTheData objectForKey:[[self.cookieLists objectAtIndex:listIndex] name]] count];
    
}

- (GSCookie *)getGSCookieForList:(NSUInteger)listIndex cookieIndex:(NSUInteger)cookieIndex  {
    
    CookieListName *cookieListName = [self.cookieLists objectAtIndex:listIndex];
    NSMutableArray *allCookies = [self.allTheData objectForKey:cookieListName.name];
    return [allCookies objectAtIndex:cookieIndex];
    
}

- (void)updateAllWithPrice:(NSString *)price  {
    NSLog(@"[DEBUG] ***AppData:updateAllWithPrice***");
    for (CookieListName *cookieListName in self.cookieLists)  {
        [self updateList:cookieListName.name withPrice:price];
    }

}

- (void)updateList:(NSString *)listName withPrice:(NSString *)price {
    NSLog(@"[DEBUG] AppData:updateListwithPrice - Updating list %@",listName);
    NSMutableArray *allCookies = [self.allTheData objectForKey:listName];
    for (GSCookie *gsCookie in allCookies) {
        gsCookie.price = [[NSDecimalNumber alloc] initWithString:price];;
    }
    
}

- (void)updateAllWithCookieTypes  {
    NSLog(@"[DEBUG] ***AppData:updateAllWithCookieTypes***");
    for (CookieListName *cookieListName in self.cookieLists)  {
        [self updateCookieTypesForList:cookieListName.name];
    }

}

- (void)updateCookieTypesForList:(NSString *)listName {
    NSLog(@"[DEBUG] AppData:updateCookieTypesForList - Updating list %@",listName);
    NSMutableArray *allCookies = [self.allTheData objectForKey:listName];
    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    
    // Remove cookies that do not exist in the cookie types any more
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    //for (GSCookie *gsCookie in allCookies) {
    for (unsigned i = 0; i < [allCookies count]; i++) {
        GSCookie *gsCookie = [allCookies objectAtIndex:i];
        // Need to update the cookie name, ie remove or add
        BOOL foundCookieType = NO;
        for (unsigned j = 0; j < [globalSettings.cookieTypes count]; j++) {
            NSString *cookieTypeName = [globalSettings.cookieTypes objectAtIndex:j];
            if ([gsCookie.name isEqualToString:cookieTypeName]) {
                foundCookieType = YES;
                break;
            }
        }
        if (!foundCookieType) {
            [indexes addIndex:i];
        }
    }
    [allCookies removeObjectsAtIndexes:indexes];
    
    // Add cookies that exist in cookie types, but do not exist in the current list
    for (unsigned i = 0; i < [globalSettings.cookieTypes count]; i++) {
        NSString *cookieTypeName = [globalSettings.cookieTypes objectAtIndex:i];
        BOOL foundCookieType = NO;
        for (unsigned j = 0; j < [allCookies count]; j++) {
            GSCookie *gsCookie = [allCookies objectAtIndex:j];
            if ([cookieTypeName isEqualToString:gsCookie.name]) {
                foundCookieType = YES;
                break;
            }
        }
        if (!foundCookieType) {
            //Add the cookieTypeName to allCookies for the list
            GSCookie *gscookie = [[GSCookie alloc] init];
            gscookie.name = cookieTypeName;
            gscookie.price = [[NSDecimalNumber alloc] initWithString:globalSettings.cookiePrice];
            gscookie.quantity = [[NSDecimalNumber alloc] initWithString:STARTING_QTY];
            [allCookies addObject:gscookie];
            
        }
    }
    // Sort the data structure that holds the cookie count list
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [allCookies sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    // Sort the data structure that holds the cookie types
    [globalSettings.cookieTypes sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];


}


#pragma mark -
#pragma mark Private methods
- (void)replaceKey:(NSString *)aKey withKey:(NSString *)aNewKey inMutableDictionary:(NSMutableDictionary *)aDict  {
    if (![aKey isEqualToString:aNewKey])  {
        id objectToPreserve = [aDict objectForKey:aKey];
        [aDict setObject:objectToPreserve forKey:aNewKey];
        [aDict removeObjectForKey:aKey];
    }
}
@end
