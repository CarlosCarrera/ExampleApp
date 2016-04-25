//
//  Movie+CoreDataProperties.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *posterPath;
@property (nullable, nonatomic, retain) NSString *originalTitle;
@property (nullable, nonatomic, retain) NSString *overview;
@property (nullable, nonatomic, retain) NSNumber *voteAverage;
@property (nullable, nonatomic, retain) NSString *backdropPath;

@end

NS_ASSUME_NONNULL_END
