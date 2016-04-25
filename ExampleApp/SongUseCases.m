//
//  SongUseCases.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16 
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
#import "SongUseCases.h"

@implementation SongUseCases

- (void)getSongsFromArtistWithName:(NSString *)name
                           success:(void (^)(NSString *))success
                           failure:(void (^)(NSString *))failure {
    [self.restClient getSongsFromArtist:name withSuccess:^(NSArray *array) {
        if([array count]>0) {
            NSString *artistName = [array firstObject][@"artistName"];
            [self.databaseManager createSongEntities:array forArtist:artistName];
            success(artistName);
        } else {
            failure(@"No songs found");
        }
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
