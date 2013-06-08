//
//  SKGroupedTableCell.m
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import "SKGroupedTableCell.h"
#import "UIColor+Hex.h"

#define kSKCellCornerRadius 10.0f
#define kSKCellVerticalPadding 10.0f
#define kSKCellHorizontalPadding 10.0f

@interface SKGroupedTableCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) SKCellPosition cellPosition;

@end

@implementation SKGroupedTableCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}
	return self;
}

- (UILabel*) textLabel {
	if (!_textLabel) {
		self.textLabel = [UILabel new];
		_textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		_textLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_textLabel];
	}
	return _textLabel;
}

- (UILabel*) detailTextLabel {
	if (!_detailTextLabel) {
		self.detailTextLabel = [UILabel new];
		_detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
		_detailTextLabel.textColor = [UIColor colorWithHex:0x808080];
		_detailTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_detailTextLabel];
	}
	return _detailTextLabel;
}

- (UIImageView*) imageView {
	if (!_imageView) {
		self.imageView = [UIImageView new];
		[self.contentView addSubview:_imageView];
	}
	return _imageView;
}

-(void) applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
	[super applyLayoutAttributes:layoutAttributes];
	
	switch (layoutAttributes.zIndex) {
		case 0:
			self.cellPosition = SKCellPositionTop;
			break;
		case 1:
			self.cellPosition = SKCellPositionMiddle;
			break;
		case 2:
			self.cellPosition = SKCellPositionBottom;
			break;
		case 3:
			self.cellPosition = SKCellPositionSingle;
			break;
		default:
			break;
	}
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect workingRect = self.contentView.bounds;
	workingRect = CGRectInset(workingRect, 6 + kSKCellHorizontalPadding, 6);
	CGRect imageRect = CGRectZero, textRect = workingRect, detailTextRect = CGRectZero;
	
	if (_imageView) {
		CGRectDivide(workingRect, &imageRect, &workingRect, workingRect.size.height, CGRectMinYEdge);
	}
	
	if (_detailTextLabel) {
		CGRectDivide(workingRect, &textRect, &detailTextRect, workingRect.size.height/2, CGRectMinYEdge);
	}
	
	[self.contentView bringSubviewToFront:_textLabel];
	
	if (_imageView) {
		self.imageView.frame = imageRect;
	}
	if (_textLabel) {
		self.textLabel.frame = textRect;
	}
	if (_detailTextLabel) {
		self.detailTextLabel.frame = detailTextRect;
	}
}

- (void) drawRect:(CGRect)aRect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	NSInteger lineWidth = 1;
	
	CGRect rect = [self bounds];
	
	CGContextSetStrokeColorWithColor(c, [UIColor colorWithHex:0xababab].CGColor);
	
	CGContextSetFillColorWithColor(c, [UIColor colorWithHex:0xf7f7f7].CGColor);
	
	CGContextSetLineWidth(c, lineWidth);
	CGContextSetAllowsAntialiasing(c, YES);
	CGContextSetShouldAntialias(c, YES);
	
	CGPathRef path = [self newRoundedPathForRect:rect cellPosition:self.cellPosition];
	
	CGContextAddPath(c, path);
	CGContextFillPath(c);
	CGContextAddPath(c, path);
	CGContextStrokePath(c);
	
	if (path != NULL) {
		CFRelease(path);
	}
	
	return;
}

- (CGPathRef) newRoundedPathForRect:(CGRect)rect cellPosition:(SKCellPosition)cellPosition {
	
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	minx += kSKCellHorizontalPadding;
	maxx -= kSKCellHorizontalPadding;
	
	if (cellPosition == SKCellPositionTop) {
		miny += 1; //subtract one because otherwise the cell clips, i think the stroke strokes the middle, not the inside or the outside
		CGPathMoveToPoint(path, NULL, minx, maxy);
		CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kSKCellCornerRadius);
		CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, kSKCellCornerRadius);
		CGPathAddLineToPoint(path, NULL, maxx, maxy);
		CGPathAddLineToPoint(path, NULL, minx, maxy);
		CGPathCloseSubpath(path);
	} else if (cellPosition == SKCellPositionBottom) {
		maxy -= 1; //see above
		CGPathMoveToPoint(path, NULL, minx, miny);
		CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, kSKCellCornerRadius);
		CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, kSKCellCornerRadius);
		CGPathAddLineToPoint(path, NULL, maxx, miny);
		CGPathAddLineToPoint(path, NULL, minx, miny);
		CGPathCloseSubpath(path);
	} else if (cellPosition == SKCellPositionMiddle) {
		CGPathMoveToPoint(path, NULL, minx, miny);
		CGPathAddLineToPoint(path, NULL, maxx, miny);
		CGPathAddLineToPoint(path, NULL, maxx, maxy);
		CGPathAddLineToPoint(path, NULL, minx, maxy);
		CGPathAddLineToPoint(path, NULL, minx, miny);
		CGPathCloseSubpath(path);
	} else if (cellPosition == SKCellPositionSingle) {
		miny += 1; //see above
		maxy -= 1; //see above
		CGPathMoveToPoint(path, NULL, minx, midy);
		CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kSKCellCornerRadius);
		CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, kSKCellCornerRadius);
		CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, kSKCellCornerRadius);
		CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, kSKCellCornerRadius);
		CGPathCloseSubpath(path);
	}
	return path;
}


@end
