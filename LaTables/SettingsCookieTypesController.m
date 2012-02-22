//
//  SettingsCookieTypesController.m
//  CookieCounter
//
//  Created by Shelley Barnes on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsCookieTypesController.h"
#import "GlobalSettings.h"
#import "AddCookieTypeViewController.h"

@implementation SettingsCookieTypesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    GlobalSettings *globalSettings = [GlobalSettings sharedManager];
    cookieTypes = [NSMutableArray arrayWithArray:globalSettings.cookieTypes];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    cookieTypes = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (YES);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.editing)  {
    return [cookieTypes count] + 1;
    }
    return [cookieTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CookieTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog(@"cellforRowAtIndexPath %d %d %@",indexPath.row, [cookieTypes count], self.editing ? @"YES" : @"NO");
    if ( (self.editing == YES) && (indexPath.row == [cookieTypes count] ) ) {
        cell.textLabel.text = @"ADD";
        NSLog(@"Adding");
    }
    else  {
        cell.textLabel.text = [cookieTypes objectAtIndex:indexPath.row]; 
    }// Configure the cell...
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (self.editing == NO || !indexPath) {
        return UITableViewCellEditingStyleNone;
    }
    if (self.editing && indexPath.row == [cookieTypes count]) {
        return UITableViewCellEditingStyleInsert;
    }
    else  {
        return UITableViewCellEditingStyleDelete;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Here to delete a row");
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSLog(@"Here to add a row");
        AddCookieTypeViewController *addCookieTypeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addCookieTypeTable"];
        
        // How to know the cookie list name to pull the next screens data out of the associative array
        //CookieListName *cookieListName = [self.cookieLists objectAtIndex:indexPath.row];
        //NSLog(@"In MainTableViewController:didSelectRowAtIndexPath cookieListName: %@", cookieListName.name);
        
        // Pass along the cookie names and prices
        //cookieCountViewController.cookiesAllInfo = [allTheData objectForKey:cookieListName.name];
        //cookieCountViewController.listName = cookieListName.name;
        addCookieTypeViewController.delegate = self;
        [self.navigationController pushViewController:addCookieTypeViewController animated:YES];
        
        
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"DidselectRowAtIndexPath");
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    NSLog(@"in setEditing %@", editing ? @"YES" : @"NO");
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[cookieTypes count] inSection:0]];
    if (editing) {
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
    else  {
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma mark - AddCookieTypeViewController delegate
- (void)addCookieTypeViewControllerDidCancel:(AddCookieTypeViewController *)controller  {
    NSLog(@"SettingsCookieTypesController:didCancel");
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addCookieTypeViewControllerDidSave:(AddCookieTypeViewController *)controller  {
    NSLog(@"SettingsCookieTypesController:didSave");
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
