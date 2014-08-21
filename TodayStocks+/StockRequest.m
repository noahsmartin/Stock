//
//  StockRequest.m
//  Stocks+
//
//  Created by Noah Martin on 8/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StockRequest.h"

NSString* xmlStart = @"<?xml version='1.0' encoding='utf-8'?><request devtype=\"Apple iPhone v6.1.3\" deployver=\"Apple iPhone v6.1.3\" app=\"YGoiPhoneClient\" appver=\"1.0.1.10B329\" api=\"finance\" apiver=\"1.0.1\" acknotification=\"0000\">";

@interface StockRequest() <NSXMLParserDelegate>
@property StockGraph* graph;
@property bool open;
@property bool close;
@property bool change;
@property (strong) void (^block)(StockGraph*);
@property int count;
@end

@implementation StockRequest

// TODO: pass a block here to use as a callback
-(void)startRequestWithSymbol:(NSString *)symbol duration:(DURATION)duration withBlock:(void (^)(StockGraph *))block {
    self.block = block;
    self.graph = [[StockGraph alloc] initWithSymbol:symbol];
    
    NSString* durationString = duration == DAY ? @"1d" : @"TODO";
    NSString* body = xmlStart;
    body = [body stringByAppendingString:@"<query id=\"0\" timestamp=\"1408205199.895829\" type=\"getchart\">"];
    // TODO: actually send the right timestamp
    body = [body stringByAppendingString:[NSString stringWithFormat:@"<symbol>%@</symbol>", symbol]];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"<range>%@</range>", durationString]];
    body = [body stringByAppendingString:@"</query>"];
    body = [body stringByAppendingString:@"</request>"];

    NSMutableURLRequest* request = [self getBasicRequest];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        }
    }];
    
    request = [self getBasicRequest];
    body = xmlStart;
    body = [body stringByAppendingString:@"<query id=\"0\" timestamp=\"1408205199.895829\" type=\"getquotes\">"];
    body = [body stringByAppendingString:@"<list>"];
    body = [body stringByAppendingString:[NSString stringWithFormat:@"<symbol>%@</symbol>", symbol]];
    body = [body stringByAppendingString:@"</list>"];
    body = [body stringByAppendingString:@"<parts>symbol,price,currency,change,changepercent,marketcap,status,realtimets,realtimeprice,realtimechange,high,low,open,dividendyield,peratio,volume,averagedailyvolume,yearrange</parts>"];
    body = [body stringByAppendingString:@"</query></request>"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError) {
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
           [parser setDelegate:self];
           [parser parse];
        }
    }];
    
}

-(NSMutableURLRequest*)getBasicRequest {
    NSString* urlString = @"http://iphone-wu.apple.com/dgw?imei=3806635122142816500&apptype=finance";  // TODO: figure out the imei, maybe generate this randomly
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(self.open) {
        [self.graph setOpen:[string doubleValue]];
    } else if(self.close) {
        [self.graph setClose:[string doubleValue]];
    } else if(self.change) {
        self.graph.change = string;

    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"marketopen"]) {
        self.open = YES;
    } else if([elementName isEqualToString:@"marketclose"]) {
        self.close = YES;
    } else if([elementName isEqualToString:@"point"]) {
        [self.graph addDataPoint:[[DataPoint alloc] initWithDictionary:attributeDict]];
    } else if([elementName isEqualToString:@"change"]) {
        self.change = YES;
    }
}

-(void)parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"marketopen"]) {
        self.open = NO;
    } else if([elementName isEqualToString:@"marketclose"]) {
        self.close = NO;
    } else if([elementName isEqualToString:@"change"]) {
        self.change = NO;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.count++;
    if(self.block && self.count == 2) {
    self.block(self.graph);
    }
}

@end
