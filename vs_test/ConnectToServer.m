//
//  ConnectToServer.m
//  vs_test
//
//  Created by Fedor on 22.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import "ConnectToServer.h"

@implementation ConnectToServer

+(NSData *)sendRequestToURL:(NSString *)_URLString withJSONDictionary:(NSDictionary *)json{

    NSError * _err;
    NSData * _JSONData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&_err];

    NSLog(@"%@\n", [[NSString alloc] initWithData:_JSONData encoding:NSUTF8StringEncoding]);


    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];

    NSString * stringBoundary = @"g-ofkidnjfu094jufn__furjuf84-----grhf---oo";

    [request setURL:[NSURL URLWithString:_URLString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"json\";  \r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/x-www-form-urlencoded \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:_JSONData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    NSURLResponse * _response = nil;

    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:&_response error:&_err];

    return response;

}

@end
