//
//  PlayerVC.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "MoviesVC.h"
#import "MoviesView.h"
#import "Song.h"
#import "MoviesUseCases.h"
#import "MovieDetailVC.h"

static NSString *CellIdentifier = @"Cell";

@interface MoviesVC () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) MoviesView *view;
@property (strong, nonatomic) Song *song;
@property (strong, nonatomic) MoviesUseCases *movieUseCases;
@property (strong, nonatomic) NSArray <Movie *> *movies;

@end

@implementation MoviesVC

@dynamic view;

- (instancetype)initWithSong:(Song *)song {
    self = [super init];
    if (self) {
        self.song = song;
    }
    return self;
}

- (void)loadView {
    self.view = [MoviesView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;
    
    self.movieUseCases = [MoviesUseCases useCasesWithRestClient:[RestClient defaultClient] andDatabaseManager:[DataBaseManager sharedDataBaseManager]];

    [self loadMovies];
    
    self.title = NSLocalizedString(@"movies", nil);
    
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - Private Methods

- (void)loadMovies {
    dispatch_async(dispatch_queue_create("searchMovies", 0), ^{
        [self.movieUseCases getPopularMoviesWithSuccess:^() {
            self.movies = [[DataBaseManager sharedDataBaseManager] getAllMovies];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.tableView reloadData];
            });
        } failure:^(NSString *error) {
            NSLog(@"Error: %@",error);
        }];
    });
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.movies[indexPath.row] originalTitle];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailVC *nextVC = [[MovieDetailVC alloc] initWithMovie:self.movies[indexPath.row]];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
