//
//  SKGroupedTableCell.h
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum  {
	SKCellPositionSingle = 0,
	SKCellPositionTop,
	SKCellPositionBottom,
	SKCellPositionMiddle
} SKCellPosition;


@interface SKGroupedTableCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@end
