//
//  ViewController.m
//  URLSessionDemo
//
//  Created by chenjie on 16/4/14.
//  Copyright © 2016年 chenjie. All rights reserved.
//

#import "ViewController.h"
#import "TrackCell.h"
#import "DataRequestManager.h"

@interface ViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DataRequestManager *manager;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
    
    if (searchBar.text.length > 0) {
        __weak typeof(self) wself = self;
        [self.manager search:searchBar.text callBack:^(id results, BOOL isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                    TrackResultsEntity *resultsEntity = (TrackResultsEntity *)results;
                    wself.dataArray = resultsEntity.results;
                    [wself.tableView reloadData];
                    [wself.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                }
            });
        }];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.view removeGestureRecognizer:self.tapGesture];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.separatorStyle = self.dataArray.count == 0 ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];
    cell.delegate = self.manager;
    cell.entity = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper
- (void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

#pragma mark - getter
- (DataRequestManager *)manager {
    if (!_manager) {
        _manager = [DataRequestManager getInstance];
    }
    return _manager;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    }
    return _tapGesture;
}

@end
