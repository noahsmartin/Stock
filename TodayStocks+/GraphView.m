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
    for(int i = 0; i < 10; i++) {
        [path moveToPoint:NSMakePoint(i*lineSpacing, 0)];
        [path lineToPoint:NSMakePoint(i*lineSpacing, height)];
        [path stroke];
    }
    for(int i = 0; i < count-1; i++) {
        NSPoint point = [self cordsForDataPoint:[self.data.points objectAtIndex:i]];
        point.x = i*pointSpacing;
        NSPoint point2 = [self cordsForDataPoint:[self.data.points objectAtIndex:i+1]];
        point2.x = (i+1)*pointSpacing;
        if(((DataPoint*) [self.data.points objectAtIndex:i]).price < self.data.open) {
            [[NSColor redColor] setStroke];
        } else {
            [[NSColor greenColor] setStroke];
        }
        path = [[NSBezierPath alloc] init];
        [path setLineWidth:0];
        [path moveToPoint:point];
        [path lineToPoint:point2];
        [path stroke];
    }
    if(count > 0) {
        NSPoint point = [self cordsForDataPoint:[self.data.points objectAtIndex:0]];
        NSBezierPath* path = [[NSBezierPath alloc] init];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:point];
        for(int i = 1; i < count; i++) {
            NSPoint point = [self cordsForDataPoint:[self.data.points objectAtIndex:i]];
            point.x = i*pointSpacing;
            [path lineToPoint:point];
        }
        point = [self cordsForDataPoint:[self.data.points objectAtIndex:count-1]];
        point.x = (count-1)*pointSpacing;
        [path lineToPoint:NSMakePoint(point.x, 0)];
        [path closePath];
        
         NSGradient* fillGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.35 green:0.35 blue:0.35 alpha:0.5] endingColor:[NSColor colorWithCalibratedRed:0.15 green:0.15 blue:0.15 alpha:0.5]];
        [fillGradient drawInBezierPath:path angle:90];
    }
    
    
    // Drawing code here.
}

-(NSPoint)cordsForDataPoint:(DataPoint*)point {
    int height = self.bounds.size.height;
    double minPrice = [self.data getMinValue];
    double maxPrice = [self.data getMaxValue];
    double span = maxPrice - minPrice;
    double factor = height/span;
    double y = point.price - minPrice;
    double yPixel = y * factor;
    // TODO: actually get the real x value from the timestamp of this point instead of guessing that every point is spread equally across the x axis
    return NSMakePoint(0, yPixel);
}

@end
