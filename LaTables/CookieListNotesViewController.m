//
//  CookieListNotes.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CookieListNotesViewController.h"

@implementation CookieListNotesViewController
@synthesize notesTextView;
@synthesize notesNavigationBar;
@synthesize notesCancel;
@synthesize notesDone;
@synthesize titleNavigationItem;
@synthesize delegate;
@synthesize listNotes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notesTextView.text = self.listNotes;
    
    
}


- (void)viewDidUnload
{
    [self setNotesTextView:nil];
    [self setNotesNavigationBar:nil];
    [self setNotesCancel:nil];
    [self setNotesDone:nil];
    [self setTitleNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender  {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate cookieListNotesViewControllerDidCancel:self];

    
}

- (IBAction)done:(id)sender  {
    [self.delegate cookieListNotesViewController:self didUpdateNotes:self.notesTextView.text];
}
@end
