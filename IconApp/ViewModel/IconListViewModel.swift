//
//  IconListViewModel.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

protocol IconLister {
    var icons : Icons? { get set }
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
    private var apiCaller : IconDataFetcher
    private let userDefaultsAccessor : StandardUserDefaultsAccessible
    
    init(with apiCaller : IconDataFetcher = NetworkManager(),
         userDefaultsAccessor : StandardUserDefaultsAccessible = StandardUserDefaultsAccessor()) {
        self.apiCaller = apiCaller
        self.userDefaultsAccessor = userDefaultsAccessor
    }
    
    //MARK: IconLister 
    var icons : Icons? {
        didSet {
            uiUpdater?.updateListUI()
        }
    }
    
    weak var uiUpdater : IconListUIUpdater?
    
    func beginAPICall() {
        apiCaller.dataReceiver = self
        apiCaller.getIconList()
    }
    
    //pagination
    func loadNextSetOfIconResults() {
        guard let icons = self.icons else {
            return
        }
        let page = userDefaultsAccessor.getIntValue(for: Constants.resultsPageKey)
        guard page > 0 else { return }
        let startingIndex = page*Constants.numberOfResultsPerPage
        
        if startingIndex < icons.count {
            var endingIndex = (startingIndex+Constants.numberOfResultsPerPage)-1
            if endingIndex > icons.count {
                endingIndex = icons.count-1
            }
            var nextIndices = [IndexPath]()
            for index in startingIndex...endingIndex {
                nextIndices.append(IndexPath(row: index, section: 0))
            }
            
            userDefaultsAccessor.set(value: page+1, for: Constants.resultsPageKey)
            self.uiUpdater?.loadNextBatchOfIcons(for: nextIndices)
        }
    }
    
    //MARK: IconDataReceivalAnnouncer
    func received(icons: Icons?) {
        self.icons = icons
        userDefaultsAccessor.set(value: 1, for: Constants.resultsPageKey)
    }
    
    func errorWhileFetchingIcons() {
        self.uiUpdater?.displayErrorMessage()
    }
}

protocol StandardUserDefaultsAccessible {
    func set(value : Int, for key: String)
    func getIntValue(for key: String) -> Int
}

final class StandardUserDefaultsAccessor : StandardUserDefaultsAccessible {
    private let defaults : UserDefaults
    
    init(with defaults : UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func set(value : Int, for key: String) {
        defaults.setValue(value, forKey: key)
    }
    
    func getIntValue(for key: String) -> Int {
        guard let value = defaults.value(forKey: key) as? Int else {
            return 0
        }
        return value
    }
}
