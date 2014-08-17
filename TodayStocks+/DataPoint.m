//
//  DataPoint.m
//  Stocks+
//
//  Created by Noah Martin on 8/16/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DataPoint.h"

@interface DataPoint()
@property int timestamp;
@property double price;
@end

@implementation DataPoint

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if(self = [super init]) {        
        self.timestamp = [[dictionary valueForKey:@"timestamp"] intValue];
        self.price = [[dictionary objectForKey:@"close"] doubleValue];
        return self;
    }
    return nil;
}

-(double)getPrice {
    return _price;
}

-(long)getTimestamp {
    return _timestamp;
}

@end
