//
//  ListRowViewController.m
//  TodayStocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "ListRowViewController.h"

@interface  ListRowViewController()
@property (weak) IBOutlet GraphView *graphView;
@property (weak) IBOutlet NSTextField *symbolName;
@property (weak) IBOutlet NSTextField *changeText;
@property (weak) IBOutlet ChangeView *changeTextBackground;
@property BOOL percent;
@property id<ChangeViewDelegate> delegate;

@end

@implementation ListRowViewController

- (NSString *)nibName {
    return @"ListRowViewController";
}

- (void)loadView {
    [super loadView];
    self.percent = NO;
    [self.changeTextBackground setDelegate:self.delegate];
}

-(void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    self.graphView.data = self.representedObject;
    self.symbolName.stringValue = ((StockGraph*) self.representedObject).symbol;
    double change = [((StockGraph*) self.representedObject).change doubleValue];
    [self setText];
    [self.changeTextBackground setChange:change >= 0];
}

-(void)clicked {
    self.percent = !self.percent;
    [self setText];
}

-(void)setColorCoded:(BOOL)colorCoded {
    self.graphView.colorCoded = colorCoded;
}

-(void)setText {
    NSString* text;
    if(self.percent) {
        double change = ((StockGraph*) self.representedObject).changepercent;
        text = [NSString stringWithFormat:@"%.2f%@", [self positiveValue:change], @"%"];
    } else {
        double change = [((StockGraph*) self.representedObject).change doubleValue];
    text = [NSString stringWithFormat:@"%.2f", [self positiveValue:change]];
    }
    self.changeText.stringValue = text;
}

-(double)positiveValue:(double)value {
    if(value < 0)
        return -1 * value;
    return value;
}

-(void)setChangeDelegate:(id<ChangeViewDelegate>)delegate {
    self.delegate = delegate;
    [self.changeTextBackground setDelegate:delegate];
}

@end
