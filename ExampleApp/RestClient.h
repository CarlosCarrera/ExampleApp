//
//  RestClient.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface RestClient : AFHTTPSessionManager

+ (instancetype)defaultClient;

- (void)getSongsFromArtist:(NSString *)name withSuccess:(void (^)(NSArray *))success
                                                failure:(void (^)(NSString *))failure;

- (void)getPopularMoviesFromFilewithSuccess:(void (^)(NSDictionary *))success
                                    failure:(void (^)(NSString *))failure;
@end
