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
}

protocol IconListUIUpdater : AnyObject {
    func updateListUI()
    func displayErrorMessage()
}

class IconListViewModel : IconLister, IconDataReceivalAnnouncer {
    private var apiCaller : IconDataFetcher
    
    init(with apiCaller : IconDataFetcher = NetworkManager()) {
        self.apiCaller = apiCaller
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
    
    //MARK: IconDataReceivalAnnouncer
    func received(icons: Icons?) {
        self.icons = icons
    }
    
    func errorWhileFetchingIcons() {
        self.uiUpdater?.displayErrorMessage()
    }
}
