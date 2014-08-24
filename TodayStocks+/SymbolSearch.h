//
//  SymbolSearch.h
//  Stocks+
//
//  Created by Noah Martin on 8/24/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymbolSearch : NSObject

-(void)lookupSymbol:(NSString*)symbol withBlock:(void (^)(NSArray*))block;

@end
