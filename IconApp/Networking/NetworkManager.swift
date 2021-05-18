//
//  NetworkManager.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

protocol IconDataFetcher : AnyObject {
    func getIconList()
}

protocol IconDataReceivalAnnouncer : AnyObject {
    func received(icons : Icons)
    func errorWhileFetchingIcons()
}

final class NetworkManager : IconDataFetcher {
    weak var dataReceiverDelegate : IconDataReceivalAnnouncer?
    
    private var network: DataFetchable = Network()
    
    //MARK: IconDataFetcher methods
    func getIconList() {
        network.fetch(from: NetworkConstants.baseUrl.rawValue) { [weak self] result in
            switch(result) {
            
            case .success(let data):
                var iconData : IconData
                do {
                    iconData = try JSONDecoder().decode(IconData.self, from: data)
                    self?.dataReceiverDelegate?.received(icons: iconData.icons)
                } catch {
                    self?.dataReceiverDelegate?.errorWhileFetchingIcons()
                }
                break
                
            case .failure( _):
                self?.dataReceiverDelegate?.errorWhileFetchingIcons()
                break
            }
        }
    }
}
