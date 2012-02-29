//
//  CookieListNotes.h
//  CookieCounter
//
//  Created by Shelley Barnes on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class CookieListNotesViewController;

@protocol CookieListNotesViewControllerDelegate <NSObject>

- (void)cookieListNotesViewControllerDidCancel: (CookieListNotesViewController *)controller;
- (void)cookieListNotesViewController:(CookieListNotesViewController *)controller didUpdateNotes:(NSString *) theListNotes;


@end


@interface CookieListNotesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UINavigationBar *notesNavigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *notesCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *notesDone;


@property (strong, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

@property (nonatomic, weak) id <CookieListNotesViewControllerDelegate> delegate;
@property(nonatomic, retain)NSString *listNotes;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
