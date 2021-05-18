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
}

protocol IconListUIUpdater : AnyObject {
    func updateListUI()
    func displayErrorMessage()
}

class IconListViewModel : IconLister, IconDataReceivalAnnouncer {
    private var apiCaller : IconDataFetcher = NetworkManager()
    
    //MARK: IconLister implementation
    var icons : Icons = Icons()
    weak var uiUpdater : IconListUIUpdater?
    
    func beginAPICall() {
        self.apiCaller.getIconList()
    }
    //TODO: pagination
    
    //MARK: IconDataReceivalAnnouncer
    func received(icons: Icons) {
        if icons.count > 0 {
            self.icons = icons
        }
        self.uiUpdater?.updateListUI()
    }
    
    func errorWhileFetchingIcons() {
        self.uiUpdater?.displayErrorMessage()
    }
}
