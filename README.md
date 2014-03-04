

# Columnar Grouped Table View

An exploration into collection views. They’re really powerful, and if you want to use them for more than a grid, you have to get in and get creative.

This helps create a collection view that looks exactly like a grouped table view, but with multiple columns. The great thing about this would be that if you set the `numberOfColumns` to 1, it would behave exactly as a regular grouped table view, allowing us to use the same classes and code for the iPhone as we do for the iPad. It was designed for iOS 6, but shouldn't take too much changing to adapt for iOS 7.

The core of any great custom collection view lies not in the collection view, but in the layout. A layout is what handles all the wizardry behind a collection view. `UICollectionView` comes with `UICollectionViewFlowLayout` by default, and that’s great for making simple grids of roughly equally-sized items. To get make anything more complex, however, you have to make a custom `UICollectionViewLayout`.

## Technique

This is commonly known as the Waterfall layout or Pinterest-style. I used a lot of the same ideas as [this UICollectionViewLayout](https://github.com/chiahsien/UICollectionViewWaterfallLayout) but simplified and added the ability to have multiple sections.

All of the calculation happens in `-prepareLayout`, since each cell’s location depends on all the cells before it. The class determines all the attributes for all the cells and caches them, presenting them to the collection view when requested.

Once we have the cells positioned where we want them, we also need to style them like a grouped tableview. The most difficult part of this is determining whether the cell should be drawn as a top, middle, bottom, or single cell (i.e., which corners should be rounded). To calculate this, you not only need to know the index path of that cell, but also how many other cells are in that section.

This isn’t appropriate information to be storing inside a cell, but it fits much better inside the layout. The problem, then, is that the layout doesn’t have access to the cell objects, only to the `layoutAttributes` property. I considered subclassing `UICollectionViewLayoutAttributes` to add a position property that would store information about how to draw the cell, but instead, since I wasn’t using the `zIndex` property of the attributes (since none of the cells overlap, I put that information in there. Then, in the `-applyLayoutAttributes:` method of the cell, I took that information out and used it to determine the cell’s position type. From there, the cell can draw itself with relative ease.

## Things to add

iOS 7 styles would be great.
