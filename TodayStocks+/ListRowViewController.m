//
//  ListRowViewController.m
//  TodayStocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "GraphView.h"
#import "ListRowViewController.h"

@interface  ListRowViewController()
@property (weak) IBOutlet GraphView *graphView;
@property (weak) IBOutlet NSTextField *symbolName;
@property (weak) IBOutlet NSTextField *changeText;

@end

@implementation ListRowViewController

- (NSString *)nibName {
    return @"ListRowViewController";
}

- (void)loadView {
    [super loadView];
    // Insert code here to customize the view
}

-(void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    self.graphView.data = self.representedObject;
    self.symbolName.stringValue = ((StockGraph*) self.representedObject).symbol;
    // TODO: change this changeText to a custom UI component that has a green background if + and red if -
    self.changeText.stringValue = [NSString stringWithFormat:@"%.2f", [((StockGraph*) self.representedObject).change doubleValue]];
}

@end
