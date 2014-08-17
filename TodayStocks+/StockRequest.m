//
//  StockRequest.m
//  Stocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StockRequest.h"
#import "StockGraph.h"

@interface StockRequest() <NSXMLParserDelegate>
@property StockGraph* graph;
@property bool open;
@property bool close;
@end

@implementation StockRequest

// TODO: pass a block here to use as a callback
-(void)startRequestWithSymbol:(NSString *)symbol duration:(DURATION)duration {
    NSString* durationString = duration == DAY ? @"1d" : @"TODO";
    NSString* urlString = @"http://iphone-wu.apple.com/dgw?imei=3806635122142816500&apptype=finance";  // TODO: figure out the imei, maybe generate this randomly
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString* body = @"<?xml version='1.0' encoding='utf-8'?><request devtype=\"Apple iPhone v6.1.3\" deployver=\"Apple iPhone v6.1.3\" app=\"YGoiPhoneClient\" appver=\"1.0.1.10B329\" api=\"finance\" apiver=\"1.0.1\" acknotification=\"0000\">";
    body = [body stringByAppendingString:@"<query id=\"0\" timestamp=\"1408205199.895829\" type=\"getchart\">"];
    // TODO: actually send the right timestamp
    body = [body stringByAppendingString:[NSString stringWithFormat:@"<symbol>%@</symbol>", symbol]];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"<range>%@</range>", durationString]];
    body = [body stringByAppendingString:@"</query>"];
    body = [body stringByAppendingString:@"</request>"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            NSLog(@"finished");
            self.graph = [[StockGraph alloc] init];
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        }
    }];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(self.open) {
        [self.graph setOpen:[string doubleValue]];
    } else if(self.close) {
        [self.graph setClose:[string doubleValue]];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"marketopen"]) {
        self.open = YES;
    } else if([elementName isEqualToString:@"marketclose"]) {
        self.close = YES;
    }else if([elementName isEqualToString:@"point"]) {
        [self.graph addDataPoint:[[DataPoint alloc] initWithDictionary:attributeDict]];
    }
}

-(void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"marketopen"]) {
        self.open = NO;
    } else if([elementName isEqualToString:@"marketclose"]) {
        self.close = YES;
    }
}

@end
