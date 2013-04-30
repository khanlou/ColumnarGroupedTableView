//
//  SKViewController.h
//  ColumnarGroupedTableView
//
//  Created by Soroush Khanlou on 4/29/13.
//  Copyright (c) 2013 Planetary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;



@end
