//
//  MasterViewController.m
//  Drupal8iOS
//
//  Created by Michael Smith on 7/11/15.
//  Copyright (c) 2015 PikLips. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SpecifyDrupalSiteViewController.h"
#import "Developer.h"  // MAS: for development only, see which

@interface MasterViewController ()

@property NSMutableArray *d8MenuItems;
@property NSMutableArray *d8MenuLinks;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void) loadMenus {

    /*  MAS:
     *  This creates an array of menu items for the Master Navigation.  This
     *  allows the detail view to retain its position in the split view while
     *  keeping the menu item views in code for easier refactoring (see
     *  DetailViewController).  It also allows the methods above to alter
     *  the table if certain menu items are unnecessary, such as when the Drupal
     *  site has been previously entered or the user signed in.  See above.
     */

    if ( !self.d8MenuItems ) {
        self.d8MenuItems = [[NSMutableArray alloc] init];
    }
    [self.d8MenuItems insertObject:@"View Articles" atIndex: 0];
    [self.d8MenuItems insertObject:@"Upload Picture" atIndex: 0];
    [self.d8MenuItems insertObject:@"Download Picture" atIndex: 0];
    [self.d8MenuItems insertObject:@"Delete File" atIndex: 0];
    [self.d8MenuItems insertObject:@"Upload File" atIndex: 0];
    [self.d8MenuItems insertObject:@"Download File" atIndex: 0];
    [self.d8MenuItems insertObject:@"Manage User Account" atIndex: 0];
    [self.d8MenuItems insertObject:@"Logout" atIndex: 0];
    [self.d8MenuItems insertObject:@"Login" atIndex: 0];
    [self.d8MenuItems insertObject:@"Setup Drupal Account" atIndex: 0];
    [self.d8MenuItems insertObject:@"Specify Drupal Site" atIndex: 0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadMenus]; // MAS: set up the table titles and the corresponding links
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.d8MenuItems) {
        self.d8MenuItems = [[NSMutableArray alloc] init];
    }
    [self.d8MenuItems insertObject:[NSDate date] atIndex:0]; // MAS: add date as cell text
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /* MAS:  Pass the menu item to the Detail View Controller --
     */
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath  = [self.tableView indexPathForSelectedRow];
        NSString *object        = self.d8MenuItems[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    /* MAS end
     */
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.d8MenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.d8MenuItems[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.d8MenuItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
