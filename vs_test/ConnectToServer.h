//
//  ConnectToServer.h
//  vs_test
//
//  Created by Fedor on 22.04.16.
//  Copyright (c) 2016 CHAPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectToServer : NSObject

+ (NSData *) sendRequestToURL:(NSString *)_URLString withJSONDictionary:(NSDictionary *)json;

@end
