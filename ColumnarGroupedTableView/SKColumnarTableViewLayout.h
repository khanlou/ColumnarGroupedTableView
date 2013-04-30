//
//  SKColumnarTableViewLayout.h
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKColumnarTableViewLayoutDelegate;

@interface SKColumnarTableViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SKColumnarTableViewLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat rowHeight;

@end


@protocol SKColumnarTableViewLayoutDelegate <NSObject>
@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SKColumnarTableViewLayout *)layout  heightForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SKColumnarTableViewLayout *)layout titleForHeaderInSection:(NSInteger)section;
@end
