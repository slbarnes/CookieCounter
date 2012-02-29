//
//  GlobalSettings.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSettings : NSObject  {
    NSString *cookiePrice;
    NSMutableArray *cookieTypes;
}

@property (nonatomic, retain) NSString *cookiePrice;
@property (nonatomic, retain) NSMutableArray *cookieTypes;

+ (id)sharedManager;

@end
