//
//  CookieListName.m
//  LaTables
//
//  Created by Shelley Barnes on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CookieListName.h"

@implementation CookieListName
@synthesize name;
@synthesize sowSoftwareListOrder;
@synthesize sowSoftwareListNotes;
@synthesize donation;
@synthesize paid;
@synthesize delivered;
@synthesize listCountBy;

- (id)init  {
    self = [super init];
    if (self) {
        name = @"";
        sowSoftwareListOrder = @"";
        sowSoftwareListNotes = @"";
        donation = @"0.00";
        paid = @"0";
        delivered = @"0";
        listCountBy = @"99";
    }
    
    return self;
}

@end
