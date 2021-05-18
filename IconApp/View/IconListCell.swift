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

protocol CellUICustomiser : UITableViewCell {
    func addRoundedCorners()
    func addShadow()
}

class IconListCell : UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var iconImageView : UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func populate(with values: Icon) {
        updateCell(with: values)
    }
}

extension IconListCell : CellUpdater, CellUICustomiser {
    //MARK: CellUpdater
    internal func updateCell(with icon : Icon) {
        self.title.text = icon.title
        self.subTitle.text = icon.subtitle
        downloadImage(from: icon.image)
        addRoundedCorners()
        addShadow()
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
    
    //MARK: CellUICustomiser
    internal func addRoundedCorners() {
        self.iconImageView?.layer.cornerRadius = CGFloat(Constants.cornerRadiusForRoundedEdges)
        self.contentView.layer.cornerRadius = CGFloat(Constants.cornerRadiusForRoundedEdges)
    }
    
    internal func addShadow() {
        self.contentView.layer.shadowOffset = CGSize (width: 0.0, height: 2.0)
        self.contentView.layer.shadowColor = UIColor.systemGray.cgColor
        self.contentView.layer.shadowOpacity = 0.4
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.masksToBounds = false
    }
}
