//
//  AppUseCasesBase.h
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"
#import "RestClient.h"

@interface UseCasesBase : NSObject

@property (nonatomic, strong) RestClient *restClient;
@property (nonatomic, strong) DataBaseManager *databaseManager;

+ (instancetype)useCasesWithRestClient:(RestClient *)restClient andDatabaseManager:(DataBaseManager *)databaseManager;

@end
