//
//  GraphView.m
//  Stocks+
//
//  Created by Noah Martin on 8/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

-(instancetype)initWithFrame:(NSRect)frameRect {
    _colorCoded = YES;
    return [super initWithFrame:frameRect];
}

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
        DataPoint* data1 = ((DataPoint*) [self.data.points objectAtIndex:i]);
        DataPoint* data2 = ((DataPoint*) [self.data.points objectAtIndex:i+1]);
        NSPoint point = [self cordsForDataPoint:data1];
        point.x = i*pointSpacing;
        NSPoint point2 = [self cordsForDataPoint:data2];
        point2.x = (i+1)*pointSpacing;
        path = [[NSBezierPath alloc] init];
        [path moveToPoint:point];
        if(self.colorCoded) {
            if(data1.price < self.data.open && data2.price < self.data.open) {
                [[NSColor redColor] setStroke];
            } else if(data1.price < self.data.open) {
                [[NSColor redColor] setStroke];
                NSPoint changePoint = [self cordsForDataPointPrice:self.data.open];
                double slopeInverse = (point2.x - point.x) / (point2.y - point.y);
                changePoint.x = point.x + (changePoint.y - point.y) * slopeInverse;
                [path lineToPoint:changePoint];
                [path stroke];
                path = [[NSBezierPath alloc] init];
                [path moveToPoint:changePoint];
                [[NSColor greenColor] setStroke];
            } else if(data2.price < self.data.open) {
                [[NSColor greenColor] setStroke];
                NSPoint changePoint = [self cordsForDataPointPrice:self.data.open];
                double slopeInverse = (point2.x - point.x) / (point2.y - point.y);
                changePoint.x = point.x + (changePoint.y - point.y) * slopeInverse;
                [path lineToPoint:changePoint];
                [path stroke];
                path = [[NSBezierPath alloc] init];
                [path moveToPoint:changePoint];
                [[NSColor redColor] setStroke];
            }else {
                [[NSColor greenColor] setStroke];
            }
        } else {
            [[NSColor whiteColor] setStroke];
        }
        [path setLineWidth:0];
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
}

-(void)setColorCoded:(BOOL)colorCoded {
    _colorCoded = colorCoded;
    [self setNeedsDisplay:YES];
}

-(NSPoint)cordsForDataPoint:(DataPoint*)point {
    return [self cordsForDataPointPrice:point.price];
}

-(NSPoint)cordsForDataPointPrice:(double)price {
    int height = self.bounds.size.height;
    double minPrice = [self.data getMinValue];
    double maxPrice = [self.data getMaxValue];
    double span = maxPrice - minPrice;
    double factor = height/span;
    double y = price - minPrice;
    double yPixel = y * factor;
    // TODO: actually get the real x value from the timestamp of this point instead of guessing that every point is spread equally across the x axis
    return NSMakePoint(0, yPixel);
}

@end
