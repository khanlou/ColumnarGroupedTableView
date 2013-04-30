//
//  SKViewController.m
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import "SKViewController.h"
#import "SKColumnarTableViewLayout.h"
#import "SKGroupedTableCell.h"

#define CELL_COUNT 30
#define kSKCellIdentifier @"aCell"

@interface SKViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SKViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.dataSource = @[ @[@"adsfsd", @"adsfsd", @"adsfsd", @"adsfsd"], @[@"adsfsd", @"adsfsd", @"adsfsd", @"adsfsd"], @[@"adsfsd", @"adsfsd", @"adsfsd", @"adsfsd"]];
	
	[self.collectionView registerClass:[SKGroupedTableCell class] forCellWithReuseIdentifier:kSKCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return ((NSArray*)_dataSource[section]).count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	SKGroupedTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSKCellIdentifier forIndexPath:indexPath];
	
	cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
	cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row];
	
	return cell;
}



@end
