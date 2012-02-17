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
        cookiePrice = [[NSString alloc] initWithString:@"3.50"];
        cookieTypes = [NSArray arrayWithObjects:@"Do-si-dos",@"Samoas",@"Savannah Smiles",@"Tagalongs",@"Thin Mints",@"Trefoils", nil];
    }
    return self;
}
- (void)dealloc  {
    //Should never be called
}
@end
