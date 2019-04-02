//  Copyright © 2019 Software101. All rights reserved.

import UIKit

class CellSizing {
    private var numberOfColumns: Int
    let minimumCellWidth: Float
    let cellHeight: CGFloat
    let cellSpacing: CGFloat

    init(
        numberOfColumns: Int = 2,
        minimumCellWidth: Float = 150,
        cellHeight: CGFloat = 350,
        cellSpacing: CGFloat = 0.5
    ) {
        self.numberOfColumns = numberOfColumns
        self.minimumCellWidth = minimumCellWidth
        self.cellHeight = cellHeight
        self.cellSpacing = cellSpacing
    }
    
    private func calculateCellWidth(containerWidth: Float, cellPadding: Float, minCellWidth: Float) -> Float {
        let numberOfColumns = Float(floor(containerWidth / (minCellWidth + cellPadding)))
        let availableWidth = Float(containerWidth - ((numberOfColumns - 1) * cellPadding))
        let cellWidth = availableWidth / numberOfColumns
        self.numberOfColumns = Int(numberOfColumns)
        return cellWidth
    }
    
    func refreshCellSize(width: Float) -> CGSize {
        let maxWidth = width
        let cellWidth = CGFloat(calculateCellWidth(containerWidth: maxWidth, cellPadding: Float(cellSpacing), minCellWidth: minimumCellWidth))
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
