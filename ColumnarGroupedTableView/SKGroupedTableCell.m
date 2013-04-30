//
//  SKGroupedTableCell.m
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import "SKGroupedTableCell.h"

@interface SKGroupedTableCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SKGroupedTableCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (UILabel*) textLabel {
	if (!_textLabel) {
		self.textLabel = [UILabel new];
		_textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		[self.contentView addSubview:_textLabel];
	}
	return _textLabel;
}

- (UIColor*) generateRandomColor {
	CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
	CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
	UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
	return color;
}

- (UILabel*) detailTextLabel {
	if (!_detailTextLabel) {
		self.detailTextLabel = [UILabel new];
		_detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
		_detailTextLabel.textColor = [UIColor lightGrayColor];
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

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect workingRect = self.contentView.bounds;
	workingRect = CGRectInset(workingRect, 2, 2);
	CGRect imageRect = CGRectZero, textRect = workingRect, detailTextRect = CGRectZero;
	
	if (_imageView) {
		CGRectDivide(workingRect, &imageRect, &workingRect, workingRect.size.height, CGRectMinYEdge);
	}
	
	if (_detailTextLabel) {
		CGRectDivide(workingRect, &textRect, &detailTextRect, workingRect.size.height/2, CGRectMinYEdge);
	}
	
	[self.contentView bringSubviewToFront:_textLabel];
	
	self.imageView.frame = imageRect;
	self.textLabel.frame = textRect;
	self.detailTextLabel.frame = detailTextRect;
}

@end
