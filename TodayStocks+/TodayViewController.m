//
//  TodayViewController.m
//  TodayStocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "TodayViewController.h"
#import "ListRowViewController.h"
#import "SymbolSearch.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate, ChangeViewDelegate>

@property (strong) IBOutlet NCWidgetListViewController *listViewController;
@property (strong) NCWidgetSearchViewController *searchController;
@property (weak) IBOutlet NSButton *colorCodedButton;
@property (weak) IBOutlet NSSegmentedControl *durationControl;
@property (strong) NSMutableArray* graphs;
@property (strong) SymbolSearch* symbolSearch;
@end


@implementation TodayViewController

#pragma mark - NSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.graphs = [[NSMutableArray alloc] init];

    // Set up the widget list view controller.
    // The contents property should contain an object for each row in the list.
    StockRequest* request = [[StockRequest alloc] init];
    [request startRequestWithSymbol:@"AAPL" duration:DAY withBlock:^(StockGraph *graph) {
        [self.graphs addObject:graph];
        self.listViewController.contents = self.graphs;
    }];
    request = [[StockRequest alloc] init];
    [request startRequestWithSymbol:@"GILD" duration:DAY withBlock:^(StockGraph *graph) {
        [self.graphs addObject:graph];
        self.listViewController.contents = self.graphs;
    }];
    self.durationControl.hidden = NO;
    self.colorCodedButton.hidden = YES;
    self.symbolSearch = [[SymbolSearch alloc] init];
}

- (void)dismissViewController:(NSViewController *)viewController {
    [super dismissViewController:viewController];

    // The search controller has been dismissed and is no longer needed.
    if (viewController == self.searchController) {
        self.searchController = nil;
    }
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Refresh the widget's contents in preparation for a snapshot.
    // Call the completion handler block after the widget's contents have been
    // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
    // or NCUpdateResultNewData to indicate that there is new data since the
    // last invocation of this method.
    completionHandler(NCUpdateResultNoData);
}

- (NSEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets)defaultMarginInset {
    // Override the left margin so that the list view is flush with the edge.
    defaultMarginInset.left = 0;
    return defaultMarginInset;
}

- (BOOL)widgetAllowsEditing {
    // Return YES to indicate that the widget supports editing of content and
    // that the list view should be allowed to enter an edit mode.
    return YES;
}

- (void)widgetDidBeginEditing {
    // The user has clicked the edit button.
    // Put the list view into editing mode.
    self.listViewController.editing = YES;
    [[self.durationControl animator] setHidden:YES];
    [[self.colorCodedButton animator] setHidden:NO];
}

- (void)widgetDidEndEditing {
    // The user has clicked the Done button, begun editing another widget,
    // or the Notification Center has been closed.
    // Take the list view out of editing mode.
    self.listViewController.editing = NO;
    [[self.durationControl animator] setHidden:NO];
    [[self.colorCodedButton animator] setHidden:YES];
}

#pragma mark - NCWidgetListViewDelegate

- (NSViewController *)widgetList:(NCWidgetListViewController *)list viewControllerForRow:(NSUInteger)row {
    // Return a new view controller subclass for displaying an item of widget
    // content. The NCWidgetListViewController will set the representedObject
    // of this view controller to one of the objects in its contents array.
    ListRowViewController* controller = [[ListRowViewController alloc] init];
    [controller setChangeDelegate:self];
    return controller;
}

- (void)widgetListPerformAddAction:(NCWidgetListViewController *)list {
    // The user has clicked the add button in the list view.
    // Display a search controller for adding new content to the widget.
    self.searchController = [[NCWidgetSearchViewController alloc] init];
    self.searchController.delegate = self;
    self.searchController.searchDescription = @"Search for a company symbol";

    // Present the search view controller with an animation.
    // Implement dismissViewController to observe when the view controller
    // has been dismissed and is no longer needed.
    [self presentViewControllerInWidget:self.searchController];
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldReorderRow:(NSUInteger)row {
    // Return YES to allow the item to be reordered in the list by the user.
    return YES;
}

- (void)widgetList:(NCWidgetListViewController *)list didReorderRow:(NSUInteger)row toRow:(NSUInteger)newIndex {
    // The user has reordered an item in the list.
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldRemoveRow:(NSUInteger)row {
    // Return YES to allow the item to be removed from the list by the user.
    return YES;
}

- (void)widgetList:(NCWidgetListViewController *)list didRemoveRow:(NSUInteger)row {
    // The user has removed an item from the list.
}

#pragma mark - NCWidgetSearchViewDelegate

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController searchForTerm:(NSString *)searchTerm maxResults:(NSUInteger)max {
    // The user has entered a search term. Set the controller's searchResults property to the matching items.
    searchController.searchResultsPlaceholderString = @"Loading...";
    [self.symbolSearch lookupSymbol:searchTerm withBlock:^(NSArray* results) {
        searchController.searchResults = results;
        searchController.searchResultsPlaceholderString = @"No results";
    }];
}

- (void)widgetSearchTermCleared:(NCWidgetSearchViewController *)searchController {
    // The user has cleared the search field. Remove the search results.
    searchController.searchResults = nil;
}

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController resultSelected:(id)object {
    // The user has selected a search result from the list.
    StockRequest* request = [[StockRequest alloc] init];
    [request startRequestWithSymbol:object duration:DAY withBlock:^(StockGraph *graph) {
        [self.graphs addObject:graph];
        self.listViewController.contents = self.graphs;
    }];
}

#pragma mark - ChangeViewDelegate

-(void)clicked {
    for(int i = 0; i < self.listViewController.contents.count; i++) {
        [[self.listViewController viewControllerAtRow:i makeIfNecessary:NO] performSelector:@selector(clicked)];
    }
}

- (IBAction)colorCodedClicked:(id)sender {
    for(int i = 0; i < self.listViewController.contents.count; i++) {
        [(ListRowViewController*) [self.listViewController viewControllerAtRow:i makeIfNecessary:NO] setColorCoded:[sender state] == NSOnState];
    }
}

@end
