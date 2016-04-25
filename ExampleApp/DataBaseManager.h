//
//  DataBaseManager.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16 
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "Movie.h"
#import "Artist.h"

@interface DataBaseManager : NSObject

+ (id)sharedDataBaseManager;

- (void)createMovieEntities:(NSDictionary *)movies;
- (NSArray *)getAllMovies;

- (void)removeArtistEntity:(NSString *)artist;
- (NSArray *)getAllArtists;

- (void)createSongEntities:(NSArray *)songs forArtist:(NSString *)artistName;
- (NSArray *)getAllSongsFromArtist:(NSString *)artistName;

-(void)saveDatabase;

@end
