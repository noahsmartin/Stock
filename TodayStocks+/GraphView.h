//
//  GraphView.h
//  Stocks+
//
//  Created by Noah Martin on 8/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StockGraph.h"
#import "ChangeView.h"

@interface GraphView : NSView

@property StockGraph* data;

@end
