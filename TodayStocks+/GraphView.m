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
    NSLog(@"draw: %ld" ,
          count);
    
    // Drawing code here.
}

@end
