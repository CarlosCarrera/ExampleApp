//
//  DataBaseManager.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16 
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "DataBaseManager.h"
#import "DataBaseContextHelper.h"

static NSString *const kEntitySong = @"Song";
static NSString *const kEntityArtist = @"Artist";
static NSString *const kEntityMovie = @"Movie";

@interface DataBaseManager()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) DataBaseContextHelper *contextHelper;

@end

@implementation DataBaseManager

+ (id)sharedDataBaseManager {
    static DataBaseManager *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contextHelper = [DataBaseContextHelper new];
        self.context = [self.contextHelper managedObjectContext];
    }
    return self;
}

#pragma mark - Public

- (void)createSongEntities:(NSArray *)songs forArtist:(NSString *)artistName {
    // Removing bd Artist before create again. Better aprox will be update them.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", artistName];
    [self removeFromEntity:kEntityArtist withPredicate:predicate];
    
    Artist *artist = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:kEntityArtist
                                                             inManagedObjectContext:self.context];
    NSMutableSet *songsSet = [NSMutableSet new];
    
    for (NSDictionary *item in songs) {
        Song *song = (Song *)[NSEntityDescription insertNewObjectForEntityForName:kEntitySong
                                                            inManagedObjectContext:self.context];
        song.trackName          = item[@"trackName"];
        song.trackId            = item[@"trackId"];
        song.artwork            = item[@"artworkUrl100"];
        song.previewUrl         = item[@"previewUrl"];
        song.collectionName     = item[@"collectionCensoredName"];
        [songsSet addObject:song];
    }
    artist.name = artistName;
    [artist addSongs:[songsSet copy]];
    
    [self.contextHelper saveContext];
}


- (void)createMovieEntities:(NSDictionary *)movies {
    // Removing bd Movie before create again. Better aprox will be update them.
    [self removeFromEntity:kEntityMovie withPredicate:nil];
    
    for (NSDictionary *item in movies) {
        Movie *aMovie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:kEntityMovie
                                                           inManagedObjectContext:self.context];
        aMovie.originalTitle    = item[@"original_title"];
        aMovie.backdropPath     = item[@"backdrop_path"];
        aMovie.posterPath       = item[@"poster_path"];
        aMovie.overview         = item[@"overview"];
        aMovie.voteAverage      = item[@"vote_average"];
    }
    [self.contextHelper saveContext];
}

- (void)removeArtistEntity:(NSString *)artist {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", artist];
    [self removeFromEntity:kEntityArtist withPredicate:predicate];
}

- (NSArray *)getAllSongsFromArtist:(NSString *)artistName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist.name == %@", artistName];
    return [self getFromEntity:kEntitySong withPredicate:predicate andSortBy:nil ascending:YES];
}

- (NSArray *)getAllArtists {
    return [self getFromEntity:kEntityArtist withPredicate:nil andSortBy:@"name" ascending:YES];
}

- (NSArray *)getAllMovies {
    return [self getFromEntity:kEntityMovie withPredicate:nil andSortBy:@"originalTitle" ascending:YES];
}

#pragma mark - Fetch operations

- (NSArray *)getFromEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andSortBy:(NSString *)sortKey
                                                                                         ascending:(BOOL)ascending {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    //Filter with predicate
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    // Sort by key
    if (sortKey) {
        NSSortDescriptor *keySort = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                ascending:ascending
                                                                 selector:@selector(localizedCaseInsensitiveCompare:)];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:keySort];
    }
    
    NSError * error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

#pragma mark - Delete operations

- (void)removeFromEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.context]];
    
    NSError *error = nil;
    NSArray *elements = [self.context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in elements) {
        [self.context deleteObject:object];
    }
    [self.contextHelper saveContext];
}

#pragma mark - Save operations

- (void)saveDatabase {
    [self.contextHelper saveContext];
}

@end
