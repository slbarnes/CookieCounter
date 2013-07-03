//
//  GlobalSettings.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalSettings.h"

static GlobalSettings *sharedGlobalSettings = nil;

@implementation GlobalSettings

@synthesize cookiePrice;
@synthesize cookieTypes;
@synthesize applySettings;

#pragma mark Singleton Methods
+ (id)sharedManager  {
    @synchronized(self)  {
        if (sharedGlobalSettings == nil)
            sharedGlobalSettings = [[self alloc] init];
    }
    return sharedGlobalSettings;
}

- (id)init  {
    if (self = [super init])  {
        cookiePrice = @"3.50";
        cookieTypes = [NSMutableArray arrayWithObjects:@"Do-si-dos",@"Dulce de Leche", @"Samoas",@"Savannah Smiles",@"Tagalongs",@"Thank U Berry Munch", @"Thin Mints",@"Trefoils", @"Troops For Troops",nil];
        applySettings = 0; // 0 - All lists 1 - New Lists
    }
    return self;
}
- (void)dealloc  {
    //Should never be called
}
@end
