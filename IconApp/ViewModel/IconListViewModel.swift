//
//  IconListViewModel.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

protocol IconLister : AnyObject {
    var icons : Icons { get set }
    var uiUpdater : IconListUIUpdater? { get set }
    func beginAPICall()
    func loadNextSetOfIconResults()
}

protocol IconListUIUpdater : AnyObject {
    func updateListUI()
    func loadNextBatchOfIcons(for indices: [IndexPath])
    func displayErrorMessage()
}

class IconListViewModel : IconLister, IconDataReceivalAnnouncer {
    private var apiCaller : IconDataFetcher = NetworkManager()
    
    //MARK: IconLister 
    var icons : Icons = Icons()
    weak var uiUpdater : IconListUIUpdater?
    
    func beginAPICall() {
        apiCaller.dataReceiver = self
        apiCaller.getIconList()
    }
    
    //pagination
    func loadNextSetOfIconResults() {
        
        guard let page = UserDefaults.standard.value(forKey: Constants.resultsPageKey) as? Int else {
            return
        }
        let startingIndex = page*Constants.numberOfResultsPerPage
        
        if startingIndex < self.icons.count {
            var endingIndex = (startingIndex+Constants.numberOfResultsPerPage)-1
            if endingIndex > self.icons.count {
                endingIndex = self.icons.count-1
            }
            var nextIndices = [IndexPath]()
            for index in startingIndex...endingIndex {
                nextIndices.append(IndexPath(row: index, section: 0))
            }
            
            UserDefaults.standard.setValue(page+1, forKey: Constants.resultsPageKey)
            self.uiUpdater?.loadNextBatchOfIcons(for: nextIndices)
        }
    }
    
    //MARK: IconDataReceivalAnnouncer
    func received(icons: Icons) {
        self.icons = icons
        UserDefaults.standard.setValue(1, forKey: Constants.resultsPageKey)
        self.uiUpdater?.updateListUI()
    }
    
    func errorWhileFetchingIcons() {
        self.uiUpdater?.displayErrorMessage()
    }
}
