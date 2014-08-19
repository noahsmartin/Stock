//
//  StockGraph.m
//  Stocks+
//
//  Created by Noah Martin on 8/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StockGraph.h"

@interface StockGraph()

@end

@implementation StockGraph

-(instancetype)initWithSymbol:(NSString *)symbol {
    if(self = [super init]) {
        self.symbol = symbol;
        self.points = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

-(void)addDataPoint:(DataPoint *)dataPoint {
    [self.points addObject:dataPoint];
}

-(void)setOpen:(double)open {
    // TODO
}

-(void)setClose:(double)close {
    // TODO
}

-(NSUInteger)numberOfPoints {
    return self.points.count;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"symbol: %@", self.symbol];
}

-(double)getMaxValue {
    double max = -1;
    for(DataPoint* point in self.points) {
        if(point.price > max) {
            max = point.price;
        }
    }
    return max;
}

-(double)getMinValue {
    // TODO: unhack this...
    double min = 99999999;
    for(DataPoint* point in self.points) {
        if(point.price < min) {
            min = point.price;
        }
    }
    return min;
}

@end
