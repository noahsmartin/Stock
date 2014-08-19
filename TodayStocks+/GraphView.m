//
//  GraphView.m
//  Stocks+
//
//  Created by Noah Martin on 8/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect bounds = self.bounds;
    int width = bounds.size.width;
    int height = bounds.size.height;
    long count = [self.data numberOfPoints];
    double pointSpacing = ((double) width)/count;
    double lineSpacing = ((double) width) / 10;
    NSBezierPath* path = [[NSBezierPath alloc] init];
    [path setLineWidth:0];
    [[NSColor grayColor] setStroke];
    for(int i = 0; i < 20; i++) {
        [path moveToPoint:NSMakePoint(i*lineSpacing, 0)];
        [path lineToPoint:NSMakePoint(i*lineSpacing, height)];
        [path stroke];
    }
    double minPrice = [self.data getMinValue];
    double maxPrice = [self.data getMaxValue];
    double span = maxPrice - minPrice;
    double factor = height/span;
    for(int i = 0; i < count-1; i++) {
        DataPoint* point = [self.data.points objectAtIndex:i];
        DataPoint* point2 = [self.data.points objectAtIndex:i+1];
        double y = point.price - minPrice;
        double yPixel = y * factor;
        double y2 = point2.price - minPrice;
        double yPixel2 = y2 * factor;
        path = [[NSBezierPath alloc] init];
        [path moveToPoint:NSMakePoint(i*pointSpacing, yPixel)];
        [path lineToPoint:NSMakePoint((i+1)*pointSpacing, yPixel2)];
        [path setLineWidth:0];
        [[NSColor whiteColor] setStroke];
        [path stroke];
    }
    
    
    // Drawing code here.
}

@end
