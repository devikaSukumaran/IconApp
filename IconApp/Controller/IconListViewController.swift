//
//  ViewController.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import UIKit

class IconListViewController: UIViewController {
    @IBOutlet weak var iconsTableView: UITableView!
    
    private var iconsViewModel : IconLister  = IconListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconsViewModel.uiUpdater = self
        iconsViewModel.beginAPICall()
    }
}

extension IconListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconsViewModel.icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.iconsListTableCellName) as? IconListCell else {
            fatalError(Constants.errorMessageForMissingCells)
        }
        
        let icon = self.iconsViewModel.icons[indexPath.row]
        cell.populate(with: icon)
        return cell
    }
}

//MARK: IconListUIUpdater
extension IconListViewController : IconListUIUpdater {
    func updateListUI() {
        DispatchQueue.main.async {
            self.iconsTableView.reloadData()
        }
    }
    
    func displayErrorMessage() {
        //TODO: display error message
    }
}
