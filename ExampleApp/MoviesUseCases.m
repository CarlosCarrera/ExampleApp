//
//  MoviesUseCases.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
#import "MoviesUseCases.h"

@implementation MoviesUseCases

- (void)getPopularMoviesWithSuccess:(void (^)())success
                            failure:(void (^)(NSString *))failure {
    [self.restClient getPopularMoviesFromFilewithSuccess:^(NSDictionary *movies) {
        
        [self.databaseManager createMovieEntities:movies];
        success();
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
