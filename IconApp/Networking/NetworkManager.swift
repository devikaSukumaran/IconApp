//
//  NetworkManager.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

protocol IconDataFetcher : AnyObject {
    var dataReceiver : IconDataReceivalAnnouncer? { get set }
    func getIconList()
}

protocol IconDataReceivalAnnouncer : AnyObject {
    func received(icons : Icons)
    func errorWhileFetchingIcons()
}

final class NetworkManager : IconDataFetcher {
    
    private var network: DataFetchable = Network()
    
    //MARK: IconDataFetcher 
    weak var dataReceiver : IconDataReceivalAnnouncer?
    
    func getIconList() {
        network.fetch(from: NetworkConstants.baseUrl.rawValue) { [weak self] result in
            switch(result) {
            
            case .success(let data):
                var iconData : IconData
                do {
                    iconData = try JSONDecoder().decode(IconData.self, from: data)
                    self?.dataReceiver?.received(icons: iconData.icons)
                } catch {
                    self?.dataReceiver?.errorWhileFetchingIcons()
                }
                break
                
            case .failure( _):
                self?.dataReceiver?.errorWhileFetchingIcons()
                break
            }
        }
    }
}
