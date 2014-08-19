//
//  StockRequest.h
//  Stocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StockGraph.h"
#import <Foundation/Foundation.h>

typedef enum _DURATION {
    DAY,
    WEEK,
    MONTH
} DURATION;

@interface StockRequest : NSObject

-(void)startRequestWithSymbol:(NSString*)symbol duration:(DURATION)duration withBlock:(void(^)(StockGraph* menu))block;

@end
