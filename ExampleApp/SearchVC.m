//
//  SearchVC.m
//  ExampleApp
//
//  Created by Carlos Carrera on 25/04/16
//  Copyright © 2016 Carlos Carrera. All rights reserved.
//

#import "SearchVC.h"
#import "SearchView.h"
#import "SongUseCases.h"
#import "DataBaseManager.h"
#import "SongsVC.h"
#import "Artist.h"

static NSString *CellIdentifier = @"Cell";

@interface SearchVC () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) SearchView *view;
@property (strong, nonatomic) NSArray <Artist *> *artists;

@end

@implementation SearchVC

@dynamic view;

- (void)loadView {
    self.view = [SearchView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setNeedsUpdateConstraints];
    
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;

    self.title = NSLocalizedString(@"music",nil);
    
    UIBarButtonItem *addArtist = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addArtist:)];
    self.navigationItem.rightBarButtonItem = addArtist;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

#pragma mark - Private Methods

- (void)searchArtist:(NSString *)artistName {
    SongsVC *nextVC = [[SongsVC alloc] initWithArtistName:artistName];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)refreshData {
    self.artists = [[DataBaseManager sharedDataBaseManager] getAllArtists];
    [self.view.tableView reloadData];
}

- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"search_artist",nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_search",nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self searchArtist:[alertController.textFields.firstObject text]];
                                                     }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_cancel",nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"artist_name",nil);
    }];
    
    [alertController addAction:okButton];
    [alertController addAction:cancelButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Actions

- (void)addArtist:(UIBarButtonItem *)sender {
    [self showAlert];
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.artists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.artists[indexPath.row] name];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self searchArtist:[(Artist *)self.artists[indexPath.row] name]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSString *artistName = [(Artist *)self.artists[indexPath.row] name];
        [[DataBaseManager sharedDataBaseManager] removeArtistEntity:artistName];
        [self refreshData];
    }
}

@end
