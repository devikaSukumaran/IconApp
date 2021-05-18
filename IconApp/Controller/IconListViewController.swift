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
        
        self.placeholderView.isHidden = false
        self.loader.startAnimating()
        iconsViewModel.uiUpdater = self
        iconsViewModel.beginAPICall()
    }
}

extension IconListViewController : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let page = UserDefaults.standard.value(forKey: Constants.resultsPageKey) as? Int {
            return iconsViewModel.icons.count > page*Constants.numberOfResultsPerPage ? page*Constants.numberOfResultsPerPage : iconsViewModel.icons.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconsListTableCellName) as? IconListCell else {
            fatalError(Constants.errorMessageForMissingCells)
        }
        let iconData = self.iconsViewModel.icons[indexPath.row]
        cell.populate(with: iconData)
        return cell
    }
    
    //Loads next set of icons if user scrolled to the end of scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRows = iconsTableView.indexPathsForVisibleRows
        guard let page = UserDefaults.standard.value(forKey: Constants.resultsPageKey) as? Int else {
            return
        }
        let resultsCount = Constants.numberOfResultsPerPage*page
        if ((visibleRows?.contains([0, resultsCount - 2])) != nil) {
            iconsViewModel.loadNextSetOfIconResults()
        }
    }
    
    //MARK: UISearchBarDelegate
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
    
    func loadNextBatchOfIcons(for indices: [IndexPath]) {
        DispatchQueue.main.async {
            self.iconsTableView.insertRows(at: indices, with: .automatic)
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
