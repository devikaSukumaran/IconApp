//
//  IconListCell.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import UIKit

protocol CellUpdater : UITableViewCell {
    func updateCell(with icon : Icon)
    func downloadImage(from imageUrl : String)
}

class IconListCell : UITableViewCell {
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    
    func populate(with values: Icon) {
        updateCell(with: values)
    }
}

extension IconListCell : CellUpdater {
    
    internal func updateCell(with icon : Icon) {
        self.title.text = icon.title
        self.subTitle.text = icon.subtitle
        downloadImage(from: icon.image)
    }
    
    internal func downloadImage(from imageUrl : String) {
        Network().fetch(from: imageUrl) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.iconImageView.image = image
                    }
                }
                break
                
            case .failure( _):
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(named: Constants.placeholderImageName)
                }
                break
            }
        }
    }
}
