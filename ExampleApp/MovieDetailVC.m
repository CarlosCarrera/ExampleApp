//
//  MovieDetailVC.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16  
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "MovieDetailVC.h"
#import "MovieDetailView.h"
#import "Movie.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailVC ()

@property (strong, nonatomic) MovieDetailView *view;
@property (strong, nonatomic) Movie *movie;

@end

@implementation MovieDetailVC

@dynamic view;

- (instancetype)initWithMovie:(Movie *)movie {
    self = [super init];
    if (self) {
        self.movie = movie;
    }
    return self;
}

-(void)loadView {
    self.view = [MovieDetailView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setNeedsUpdateConstraints];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    self.title = self.movie.originalTitle;
    
    [self.view.posterImageView setImageWithURL:[NSURL URLWithString:self.movie.backdropPath]];

    self.view.overviewTextView.text = self.movie.overview;
}

- (void)orientationChanged:(NSNotification *)notification {
    [self.view orientationChangedTo:[UIDevice currentDevice].orientation];
}

@end
