//
//  ListRowViewController.h
//  TodayStocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StockKit.h"
#import <Cocoa/Cocoa.h>

@interface ListRowViewController : NSViewController

-(void)setChangeDelegate:(id<ChangeViewDelegate>)delegate;
-(void)setColorCoded:(BOOL)colorCoded;

@end
