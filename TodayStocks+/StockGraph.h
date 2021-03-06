//
//  StockGraph.h
//  Stocks+
//
//  Created by Noah Martin on 8/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPoint.h"

@interface StockGraph : NSObject

@property NSString* symbol;
@property (strong) NSMutableArray* points;
@property (strong) NSString* change;
@property double changepercent;
@property double open;
@property double close;

-(instancetype)initWithSymbol:(NSString*)symbol;

-(void)addDataPoint:(DataPoint*)dataPoint;
-(NSUInteger)numberOfPoints;

-(double)getMinValue;
-(double)getMaxValue;

@end
