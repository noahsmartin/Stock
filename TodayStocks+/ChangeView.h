//
//  ChangeView.h
//  Stocks+
//
//  Created by Noah Martin on 8/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ChangeViewDelegate <NSObject>

-(void)clicked;

@end

@interface ChangeView : NSView

@property id<ChangeViewDelegate> delegate;

-(void)setChange:(BOOL)positive;

@end
