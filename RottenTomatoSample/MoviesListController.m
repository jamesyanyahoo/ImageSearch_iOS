//
//  MoviesListController.m
//  RottenTomatoSample
//
//  Created by James Yan on 9/19/15.
//  Copyright © 2015 James Yan. All rights reserved.
//

#import "MoviesListController.h"
#import "ViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface MoviesListController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *imageList;

@end

@implementation MoviesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageTableView.delegate = self;
    self.imageTableView.dataSource = self;
    
    // initialize the search control
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.searchController setSearchResultsUpdater:self];
    [self.searchController dimsBackgroundDuringPresentation];
    
    [self.searchController.searchBar sizeToFit];
    //self.imageTableView.tableHeaderView = self.searchController.searchBar;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = false;
    
    [self definesPresentationContext];
    
    // initialize the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshResult) forControlEvents:UIControlEventValueChanged];
    [self.imageTableView addSubview:self.refreshControl];
    
    // perform search
    [self performSearch:@"car"];
}

- (void)performSearch:(NSString *)searchTerm {
    NSLog(@"Perform search %@", searchTerm);
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSString *apiUrl = [NSString stringWithFormat: @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=%@", searchTerm];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *reponse, NSError *error) {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        self.imageList = [dict valueForKeyPath:@"responseData.results"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            [SVProgressHUD dismiss];
                            [self.imageTableView reloadData];
                        });
                    }] resume];
    });
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchTerm = searchController.searchBar.text;
    
    if (searchTerm.length >= 5) { // not a good approach
        [self performSearch:searchTerm];
    }
}

- (void)refreshResult {
    NSLog(@"refresh Result");
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *imageInfo = self.imageList[indexPath.row];
    
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    MovieCell *cell = [self.imageTableView dequeueReusableCellWithIdentifier:@"MyTableCell" forIndexPath:indexPath];
    cell.titleLabel.text = imageInfo[@"titleNoFormatting"];
    cell.summaryLabel.text = imageInfo[@"contentNoFormatting"];
    [cell.summaryLabel sizeToFit];
    
//    [cell.posterImage setImageWithURL:[NSURL URLWithString:imageInfo[@"url"]]];
    [cell.posterImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageInfo[@"url"]]]
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __weak UIImageView *imageView = cell.posterImage;
        if (imageView == nil) return;
        
        [UIView transitionWithView:imageView
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            imageView.image = image;
                        }
                        completion:nil];
        
    }
                                     failure:nil];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.imageTableView deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.imageTableView indexPathForCell:cell];
    
    ViewController *vc = [segue destinationViewController];
    vc.imageInfo = self.imageList[indexPath.row];
}

@end
