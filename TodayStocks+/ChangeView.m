//
//  ChangeView.m
//  Stocks+
//
//  Created by Noah Martin on 8/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "ChangeView.h"

@implementation ChangeView

-(void)setChange:(BOOL)positive {
    NSColor* color = positive ? [NSColor greenColor] : [NSColor redColor];
    self.layer.backgroundColor = [color CGColor];
    self.layer.cornerRadius = 3;
}

-(void)mouseUp:(NSEvent *)theEvent {
    [self.delegate clicked];
}

@end
