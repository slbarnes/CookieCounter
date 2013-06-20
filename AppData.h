//
//  AppData.h
//  CookieCounter
//
//  Created by Shelley Barnes on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCookie.h"
#import "CookieListName.h"

@interface AppData : NSObject  {
    NSMutableDictionary *allTheData;
    NSMutableArray *cookieLists;
    BOOL loadedDataFromExampleList;
}

@property (nonatomic, retain) NSMutableDictionary *allTheData;
@property (nonatomic, retain) NSMutableArray *cookieLists;


+ (id)sharedData;

- (void)setLoadedDataFromExampleList:(BOOL)yesorno;

- (BOOL)getLoadedDataFromExampleList;

- (void)writeDataToFile;

- (void)readDataFromFile;

- (void)setListNotes:(NSUInteger)listIndex :(NSString *)theNote;

- (NSString *)getListNotes:(NSUInteger)listIndex;

- (void)setDonation:(NSUInteger)listIndex :(NSString *)donation;

- (NSString *)getDonation:(NSUInteger)listIndex;

- (NSString *)getListName:(NSUInteger)listIndex;

- (void) removeCookieList:(NSUInteger)listIndex;

- (NSUInteger)getNumberOfCookieLists;

- (void)setSowSoftwareListOrder:(NSUInteger)listIndex order:(NSUInteger)order;

- (BOOL)doesCookieListNameExist:(NSString *)name;

- (void)addNewCookieList:(NSString *)name;

- (NSString *)createAllListSummary;

- (NSString *)createSummaryForOneList:(CookieListName *)cookieListName;

- (NSUInteger)getNumberOfCookiesForList:(NSUInteger)listIndex;

- (GSCookie *)getGSCookieForList:(NSUInteger)listIndex cookieIndex:(NSUInteger)cookieIndex;

@end
