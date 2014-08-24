//
//  SymbolSearch.m
//  Stocks+
//
//  Created by Noah Martin on 8/24/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "SymbolSearch.h"

@interface SymbolSearch() <NSURLConnectionDataDelegate>

@property NSURLConnection* connection;
@property NSMutableData* data;
@property (nonatomic, copy) void (^block)(NSArray*);

@end

@implementation SymbolSearch

-(void)lookupSymbol:(NSString *)symbol withBlock:(void (^)(NSArray*))block {
    [self.connection cancel];
    self.data = [[NSMutableData alloc] init];
    self.block = block;
    NSString* urlString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback", symbol];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* resultString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    resultString = [resultString substringFromIndex:[resultString rangeOfString:@"("].location+1];
    resultString = [resultString substringToIndex:resultString.length-1];
    NSArray *result = [[[NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil] objectForKey:@"ResultSet"] objectForKey:@"Result"];
    self.block([self extractSymbolFromResult:result]);
    NSLog(@"resultString: %@", result);
}

-(NSArray*)extractSymbolFromResult:(NSArray*)result {
    NSMutableArray* symbols = [NSMutableArray array];
    for(NSDictionary* dict in result) {
        [symbols addObject:[dict objectForKey:@"symbol"]];
    }
    return symbols;
}

@end
