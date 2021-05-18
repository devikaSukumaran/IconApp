//
//  IconViewModelTests.swift
//  IconAppTests
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import XCTest
@testable import IconApp

class IconViewModelTests: XCTestCase {
    let defaults = UserDefaults.init(suiteName: "test")
    var viewModel : IconLister!
    let iconListUpdater : IconListUIUpdaterMock = IconListUIUpdaterMock()
    
    func testAPISuccess() {
        let network = NetworkMock(for: true)
        let networkManager = NetworkManager(with: network)
        
        viewModel = IconListViewModel(with: networkManager, userDefaultsAccessor: StandardUserDefaultsAccessor(with: defaults ?? UserDefaults.standard))
        viewModel.uiUpdater = iconListUpdater
        
        viewModel.beginAPICall()
        XCTAssertEqual(viewModel.icons?.count , 1)
        XCTAssertTrue(iconListUpdater.uiUpdated)
        XCTAssertFalse(iconListUpdater.nextBatchLoaded)
        XCTAssertFalse(iconListUpdater.displayError)
        XCTAssertEqual(defaults?.value(forKey: Constants.resultsPageKey) as? Int , 1)
    }
    
    func testFailure() {
        let network = NetworkMock(for: false)
        let networkManager = NetworkManager(with: network)
        
        viewModel = IconListViewModel(with: networkManager, userDefaultsAccessor: StandardUserDefaultsAccessor(with: defaults ?? UserDefaults.standard))
        viewModel.uiUpdater = iconListUpdater
        
        viewModel.beginAPICall()
        XCTAssertNil(viewModel.icons)
        XCTAssertFalse(iconListUpdater.uiUpdated)
        XCTAssertTrue(iconListUpdater.displayError)
    }
}

class NetworkMock : DataFetchable {
    let success : Bool
    
    //Adding static json string to avoid using mock networking libraries
    let jsonString = "{\"icons\":[{\"title\":\"Lime Green\",\"subtitle\":\"#A5EA9B\",\"image\":\"https://irapps.github.io/wzpsolutions/tests/ios-custom-icons/LimeGreen.png\"}]}"
    
    init(for success : Bool) {
        self.success = success
    }
    
    func fetch(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let data = jsonString.data(using: .utf8) else {
            completion(.failure(.failedToFetch))
            return
        }
        
        if success {
            completion(.success(data))
        } else {
            completion(.failure(.failedToFetch))
        }
    }
}

class IconListUIUpdaterMock : IconListUIUpdater {
    var uiUpdated = false
    var nextBatchLoaded = false
    var displayError = false
    
    func updateListUI() {
        uiUpdated = true
    }
    
    func loadNextBatchOfIcons(for indices: [IndexPath]) {
        nextBatchLoaded = true
    }
    
    func displayErrorMessage() {
        displayError = true
    }
}
