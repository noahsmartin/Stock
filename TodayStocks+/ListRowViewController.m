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
@property (weak) IBOutlet NSView *changeTextBackground;

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
    double change = [((StockGraph*) self.representedObject).change doubleValue];
    self.changeText.stringValue = [NSString stringWithFormat:@"%.2f", [self positiveValue:change]];
    NSColor* color = change >= 0 ? [NSColor greenColor] : [NSColor redColor];
    self.changeTextBackground.layer.backgroundColor = [color CGColor];
    self.changeTextBackground.layer.cornerRadius = 3;
}

-(double)positiveValue:(double)value {
    if(value < 0)
        return -1 * value;
    return value;
}

@end
