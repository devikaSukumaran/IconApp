//
//  ViewController.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import UIKit

class IconListViewController: UIViewController {
    @IBOutlet weak var iconsTableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var iconsViewModel : IconLister  = IconListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderView.isHidden = false
        loader.startAnimating()
        
        iconsViewModel.uiUpdater = self
        iconsViewModel.beginAPICall()
    }
}

extension IconListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let icons = iconsViewModel.icons else {
            return 0
        }
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconsListTableCellName) as? IconListCell else {
            fatalError(Constants.errorMessageForMissingCells)
        }
        if let iconData = self.iconsViewModel.icons?[indexPath.row] {
            cell.populate(with: iconData)
        }
        return cell
    }
}

extension IconListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.endEditing(true)
    }
}

//MARK: IconListUIUpdater
extension IconListViewController : IconListUIUpdater {
    func updateListUI() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.errorMessage.isHidden = true
            self.placeholderView.isHidden = true
            self.iconsTableView.reloadData()
        }
    }
    
    func displayErrorMessage() {
        DispatchQueue.main.async {
            self.placeholderView.isHidden = false
            self.loader.stopAnimating()
            self.errorMessage.isHidden = false
        }
    }
}
