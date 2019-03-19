//
//  ProductListLayout.swift
//  Dishwashers
//
//  Created by PJ COOK on 19/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class ProductListCollectionLayout: UICollectionViewLayout {
    private var numberOfColumns = 2
    private var numberOfItems = 0
    private var cellSize: CGSize = .zero
    private let cellPadding: CGFloat = 0.5
    private let cellHeight: CGFloat = 350
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - insets.left + insets.right
    }
    
    private var contentHeight: CGFloat {
        guard numberOfItems > 0 else { return 0 }
        var rows = numberOfItems / numberOfColumns
        rows = numberOfItems % numberOfColumns == 0 ? rows : rows + 1
        return cellHeight * CGFloat(rows)
    }
    
    override var collectionViewContentSize: CGSize {
        guard numberOfItems > 0 else { return .zero }
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        refreshCellSize()
    }
    
    private func calculateCellWidth(maxWidth: Float, cellPadding: Float, minCellSize: Float) -> Float {
        let numberOfCells = Float(floor(maxWidth / (minCellSize + cellPadding)))
        let availableWidth = Float((maxWidth - ((numberOfCells - 1) * cellPadding)))
        return availableWidth / numberOfCells
    }
    
    private func refreshCellSize() {
        guard let collectionView = collectionView else { return }
        let maxWidth = Float(collectionView.frame.width)
        let cellWidth = CGFloat(calculateCellWidth(maxWidth: maxWidth, cellPadding: Float(cellPadding), minCellSize: 150))
        cellSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    private func layoutAttributes(indexPath: IndexPath, column: Int, x: CGFloat, y: CGFloat) -> UICollectionViewLayoutAttributes {
        let insetFrame = CGRect(x: cellSize.width * CGFloat(column) + cellPadding * CGFloat(max(0, column - 1)), y: y, width: cellSize.width, height: cellSize.height)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard numberOfItems > 0 else { return [] }
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        var row = floor(rect.origin.y / cellHeight)
        var y = row * cellHeight
        var itemRow = Int(row) * numberOfColumns
            - 1
        while y < rect.origin.y + rect.size.height {
            for i in (0..<numberOfColumns) {
                let indexPath = IndexPath(row: itemRow, section: 0)
                let x = cellSize.width * CGFloat(i) + cellPadding * CGFloat(max(0, i - 1))
                let attributes = layoutAttributes(indexPath: indexPath, column: i, x: x, y: y)
                visibleLayoutAttributes.append(attributes)

                itemRow += 1
            }

            row += 1
            y += cellHeight
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let row = CGFloat(floor(Double(indexPath.row / numberOfColumns)))
        let y = row * cellHeight
        let i = indexPath.row - Int(row * CGFloat(numberOfItems))
        let x = cellSize.width * CGFloat(i) + cellPadding * CGFloat(max(0, i - 1))
        return layoutAttributes(indexPath: indexPath, column: i, x: x, y: y)
    }
}
