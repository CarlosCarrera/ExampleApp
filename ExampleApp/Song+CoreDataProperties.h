//
//  Song+CoreDataProperties.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artwork;
@property (nullable, nonatomic, retain) NSString *collectionName;
@property (nullable, nonatomic, retain) NSString *previewUrl;
@property (nullable, nonatomic, retain) NSString *trackName;
@property (nullable, nonatomic, retain) NSNumber *trackId;
@property (nullable, nonatomic, retain) Artist *artist;

@end

NS_ASSUME_NONNULL_END
