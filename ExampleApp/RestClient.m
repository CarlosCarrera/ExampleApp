//
//  RestClient.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "RestClient.h"
#import "Movie.h"

static NSString *const kUrlBase = @"https://itunes.apple.com";
static NSString *const kMoviesFileName = @"movies";

@implementation RestClient

+ (instancetype)defaultClient {
    static RestClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kUrlBase]
                                  sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sharedInstance;
}

- (void)getSongsFromArtist:(NSString *)name withSuccess:(void (^)(NSArray *))success
                                                failure:(void (^)(NSString *))failure {
    NSString *urlString = @"search";
    NSDictionary *parameters = @{@"term" : name};
    NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject[@"results"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure([NSString stringWithFormat:@"%li",(long)error.code]);
        }
    }];
}

- (void)getPopularMoviesFromFilewithSuccess:(void (^)(NSDictionary *))success
                                    failure:(void (^)(NSString *))failure {
    NSDictionary *json = [self loadJSONFileWithName:kMoviesFileName];
    NSDictionary *jsonElements = json[@"results"];
    if(jsonElements){
        success(jsonElements);
    }else{
        failure(@"Error reading Json");
    }
}

#pragma mark - Private Methods

- (id)loadJSONFileWithName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSError *jsonError;
    id json = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:&jsonError];
    if (jsonError) {
        NSLog(@"Loading JSON error: %@", jsonError.localizedDescription);
    }
    return json;
}

@end
