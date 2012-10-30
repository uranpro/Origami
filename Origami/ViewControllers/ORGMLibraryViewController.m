//
//  ORGMLibraryViewController.m
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import "ORGMLibraryViewController.h"

#import "ORGMEntityWithCoverCell.h"
#import "ORGMCustomization.h"
#import "ORGMPlayerView.h"

@interface ORGMLibraryViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) NSMutableArray *entities;
@end

@implementation ORGMLibraryViewController
@synthesize tableViewOutlet = _tableViewOutlet;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.entities = [[NSMutableArray alloc] init];
        _isLoading = NO;
    }
    return self;
}

- (void)reloadData {
    NSArray *items = nil;
    switch (_controllerType) {
        case ORGMLibraryControllerArtist:
            items = [ORGMArtist libraryArtists];
            break;
        case ORGMLibraryControllerAlbum:
            items = [ORGMAlbum libraryAlbums];
            break;
        case ORGMLibraryControllerGenre:
            items = [ORGMGenre libraryGenres];
            break;
    }
    
    [_entities addObjectsFromArray:items];
    [_tableViewOutlet reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setTableFooterView:nil];
    
    [_tableViewOutlet setBackgroundView:[ORGMCustomization backgroundImage]];
    [self reloadData];
    
    ORGMPlayerView *playerView = [[ORGMPlayerView alloc] initWithFrame:CGRectNull];
    [playerView addShortControlsForNavItem:self.navigationItem];
    [playerView setViewStateChangeBlock:^(ORGMPlayerViewState newState) {
        if (newState == ORGMPlayerViewStatePresented) {
            self.sideMenuController.panGesture.enabled = NO;
        } else {
            self.sideMenuController.panGesture.enabled = YES;
        }
    }];
    [playerView presentInView:self.view
                   uponNavBar:self.navigationController.navigationBar];
    
    UIView *stripeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 2.0)];
    stripeView.backgroundColor =
        [ORGMCustomization colorForColoredEntityType:_controllerType];
    [self.navigationController.navigationBar addSubview:stripeView];
}

- (void)viewDidUnload {
    [self setTableViewOutlet:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return round(_entities.count/2.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMEntityWithCoverCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"coverCell"];
    NSInteger index = indexPath.row * 2;
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[_entities objectAtIndex:index]];
    if (index + 1 < _entities.count) {
        [items addObject:[_entities objectAtIndex:index + 1]];
    }
    [cell setEntities:items];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_isLoading) return;
//    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
//    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
//    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count/2 - 1)
//                                              inSection:0]]) {
//        [self loadNext];
//    }
}
@end
