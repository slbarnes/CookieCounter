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

    globalSettings = [GlobalSettings sharedManager];
    
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
        //return [cookieTypes count] + 1;
        return [globalSettings.cookieTypes count] + 1;

    }
    return [globalSettings.cookieTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CookieTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"cellforRowAtIndexPath %d %d %@",indexPath.row, [globalSettings.cookieTypes count], self.editing ? @"YES" : @"NO");
    if ( (self.editing == YES) && (indexPath.row == [globalSettings.cookieTypes count] ) ) {
        cell.textLabel.text = @"Add New Cookie";
        NSLog(@"Adding");
    }
    else  {
        cell.textLabel.text = [globalSettings.cookieTypes objectAtIndex:indexPath.row]; 
    }// Configure the cell...
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (self.editing == NO || !indexPath) {
        return UITableViewCellEditingStyleNone;
    }
    if (self.editing && indexPath.row == [globalSettings.cookieTypes count]) {
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
        //NSLog(@"Here to delete a row");
        [globalSettings.cookieTypes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //NSLog(@"Here to add a row");
        AddCookieTypeViewController *addCookieTypeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addCookieTypeTable"];
        
        addCookieTypeViewController.delegate = self;
        [self.navigationController pushViewController:addCookieTypeViewController animated:YES];
        //[self presentModalViewController:addCookieTypeViewController animated:YES];        
        
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
    //NSLog(@"in setEditing %@", editing ? @"YES" : @"NO");
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[globalSettings.cookieTypes count] inSection:0]];
    if (editing) {
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
    else  {
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma mark - AddCookieTypeViewController delegate

- (void)addCookieTypeViewControllerDidCancel:(AddCookieTypeViewController *)controller  {
   // NSLog(@"SettingsCookieTypesController:didCancel");
    
    // disable editing
    [self setEditing:NO animated:YES];
    // Since this controller was programatically pushed, need to pop it instead of dismiss it
    [self.navigationController popViewControllerAnimated:YES];


}

- (void)addCookieTypeViewController:(AddCookieTypeViewController *)controller didAddCookieType:(NSString *)cookieType  {
    //NSLog(@"SettingsCookieTypesController:didAddCookieType");
    
    // Grab the new cookie name, add it to the table, add it to the global list
    if (cookieType != nil) {
        //[cookieTypes addObject:cookieType];
        [globalSettings.cookieTypes addObject:cookieType];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[globalSettings.cookieTypes count] - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        
    }
    
    // Disable Editing
    [self setEditing:NO animated:YES];
    
    // Since this controller was programatically pushed, need to pop it instead of dismiss it
    [self.navigationController popViewControllerAnimated:YES];

}
@end
