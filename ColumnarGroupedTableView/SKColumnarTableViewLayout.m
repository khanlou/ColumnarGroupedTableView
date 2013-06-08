//
//  SKColumnarTableViewLayout.m
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import "SKColumnarTableViewLayout.h"

#define kSKLayoutSectionPadding 5.0f

@interface SKColumnarTableViewLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@property (nonatomic, assign) NSInteger itemCount; // attributes for each item

@end

@implementation SKColumnarTableViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	self.numberOfColumns = 2;
	self.rowHeight = 44.0f;
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns {
	if (_numberOfColumns != numberOfColumns) {
		_numberOfColumns = numberOfColumns;
		[self invalidateLayout];
	}
}

- (void) setRowHeight:(CGFloat)rowHeight {
	if (_rowHeight != rowHeight) {
		_rowHeight = rowHeight;
		[self invalidateLayout];
	}
}

- (CGSize)collectionViewContentSize
{
	if (self.itemCount == 0) {
		return CGSizeZero;
	}
	
	CGSize contentSize = self.collectionView.frame.size;
	NSUInteger columnIndex = [self longestColumnIndex];
	contentSize.height = [self.columnHeights[columnIndex] floatValue];
	return contentSize;
}


#pragma mark - Methods to Override
- (void)prepareLayout
{
	[super prepareLayout];
	
	NSInteger numberOfSections = self.collectionView.numberOfSections;
	CGFloat columnWidth = self.collectionView.frame.size.width / self.numberOfColumns;
	
	self.itemAttributes = [NSMutableArray arrayWithCapacity:numberOfSections];
	self.columnHeights = [NSMutableArray arrayWithCapacity:_numberOfColumns];
	for (NSInteger columnIndex = 0; columnIndex < _numberOfColumns; columnIndex++) {
		[_columnHeights addObject:@(0)];
	}
	
	self.itemCount = 0;
	
	// Sections are put into shortest column.
	for (NSInteger currentSection = 0; currentSection < numberOfSections; currentSection++) {
		
		NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:currentSection];
		_itemCount += numberOfItemsInSection;
		
		[_itemAttributes addObject:[NSMutableArray arrayWithCapacity:numberOfItemsInSection]];

		NSUInteger columnIndex = [self shortestColumnIndex];
		
		_columnHeights[columnIndex] =  @([_columnHeights[columnIndex] floatValue] + kSKLayoutSectionPadding); //replace this with section insets?

		for (NSInteger currentItemIndex = 0; currentItemIndex < numberOfItemsInSection; currentItemIndex++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentItemIndex inSection:currentSection];
			
			CGFloat itemHeight = self.rowHeight;
			if ([_delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]) {
				itemHeight = [_delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
			}

			CGFloat x = columnWidth * columnIndex;
			CGFloat y = [(_columnHeights[columnIndex]) floatValue];
			
			UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
			attributes.frame = CGRectMake(x, y, columnWidth, itemHeight);
			
			if (currentItemIndex == 0) {
				attributes.zIndex = 0; //top
				if (numberOfItemsInSection == 1) {
					attributes.zIndex = 3; //single
				}
			} else if (currentItemIndex == numberOfItemsInSection - 1) {
				attributes.zIndex = 2; //bottom
			} else {
				attributes.zIndex = 1; //middle
			}
			
			[_itemAttributes[currentSection] addObject:attributes];
			_columnHeights[columnIndex] = @(y + itemHeight);
		}
	}
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
	return self.itemAttributes[path.section][path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	//possibly optimize this
	NSMutableArray *attributes = [NSMutableArray array];
	for (NSInteger currentSection = 0; currentSection < self.collectionView.numberOfSections; currentSection++) {
		[attributes addObjectsFromArray:[self.itemAttributes[currentSection] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
			return CGRectIntersectsRect(rect, evaluatedObject.frame);
		}]]];
	}
	return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	return YES;
}

#pragma mark - Private Methods
- (NSUInteger)shortestColumnIndex
{
	NSNumber *minValue = [_columnHeights valueForKeyPath:@"@min.floatValue"];
	return [_columnHeights indexOfObject:minValue];
}

- (NSUInteger)longestColumnIndex
{
	NSNumber *maxValue = [_columnHeights valueForKeyPath:@"@max.floatValue"];
	return [_columnHeights indexOfObject:maxValue];
}

@end
