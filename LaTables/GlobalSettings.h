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
@property (nonatomic, assign) NSInteger applySettings; // 0 - All lists 1 - New Lists
@property (nonatomic, assign) NSInteger countBy; //0 - box 1 - case;

+ (id)sharedManager;

@end
