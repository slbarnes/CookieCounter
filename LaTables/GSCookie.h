//
//  GSCookie.h
//  LaTables
//
//  Created by Shelley Barnes on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCookie : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDecimalNumber *price;
@property (nonatomic, copy) NSDecimalNumber *quantity;
@end
