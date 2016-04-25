//
//  MoviesUseCases.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
#import "UseCasesBase.h"

@interface MoviesUseCases : UseCasesBase

- (void)getPopularMoviesWithSuccess:(void (^)())success
                            failure:(void (^)(NSString *))failure;

@end
