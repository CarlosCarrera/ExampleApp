//
//  AppUseCasesBase.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "UseCasesBase.h"

@implementation UseCasesBase

+ (instancetype)useCasesWithRestClient:(RestClient *)restClient andDatabaseManager:(DataBaseManager *)databaseManager {
    return [[self alloc] initWithRestClient:restClient andDatabaseManager:databaseManager];
}

- (instancetype)initWithRestClient:(RestClient *)restClient andDatabaseManager:(DataBaseManager *)databaseManager {
    self = [super init];
    if (self) {
        self.restClient = restClient;
        self.databaseManager = databaseManager;
    }
    return self;
}

@end
