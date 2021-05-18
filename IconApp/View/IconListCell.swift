//
//  IconListCell.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import UIKit

class IconListCell : UITableViewCell {
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    
    func populate(with values: Icon) {
        updateCell(with: values)
    }
    
    private func updateCell(with icon : Icon) {
        self.title.text = icon.title
        self.subTitle.text = icon.subtitle
    }
}
