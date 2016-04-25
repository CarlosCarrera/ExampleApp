//
//  SongUseCases.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16 
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
#import "UseCasesBase.h"

@interface SongUseCases : UseCasesBase

- (void)getSongsFromArtistWithName:(NSString *)name
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure;

@end
