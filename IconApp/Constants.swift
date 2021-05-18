//
//  Constants.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import UIKit

struct Constants {
    static let iconsListTableCellName = "iconListTableViewCell"
    static let errorMessageForMissingCells = "Tableview cell not found"
    static let placeholderImageName = "Placeholder"
    static let numberOfResultsPerPage = 10
    static let resultsPageKey = "resultsPage"
    
    
    struct IconCellUI {
        static let cornerRadiusForRoundedEdges : CGFloat = 8
        static let contentViewEdgeInset : CGFloat = 8
        
        struct Shadow {
            static let height : CGFloat  = 2.0
            static let width : CGFloat = 0.0
            static let opacity : Float =  0.25
            static let radius : CGFloat = 4
            static let color : CGColor = UIColor.systemGray.cgColor
        }
    }
}
