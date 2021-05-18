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
        
        let edgeInset = Constants.IconCellUI.contentViewEdgeInset
        contentView.frame = contentView.frame.inset(by:
                                                        UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset))
    }
    
    func populate(with values: Icon) {
        updateCell(with: values)
    }
}

extension IconListCell : CellUpdater, CellUICustomiser {
    //MARK: CellUpdater
    internal func updateCell(with icon : Icon) {
        title.text = icon.title
        subTitle.text = icon.subtitle
        
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
        iconImageView?.layer.cornerRadius = Constants.IconCellUI.cornerRadiusForRoundedEdges
        contentView.layer.cornerRadius = Constants.IconCellUI.cornerRadiusForRoundedEdges
    }
    
    internal func addShadow() {
        contentView.layer.shadowOffset = CGSize (width: Constants.IconCellUI.Shadow.width, height: Constants.IconCellUI.Shadow.height)
        contentView.layer.shadowColor = Constants.IconCellUI.Shadow.color
        contentView.layer.shadowOpacity = Constants.IconCellUI.Shadow.opacity
        contentView.layer.shadowRadius = Constants.IconCellUI.Shadow.radius
        contentView.layer.masksToBounds = false
    }
}
