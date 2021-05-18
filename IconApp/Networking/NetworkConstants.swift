//
//  NetworkConstants.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

enum NetworkError : Error {
    case failedToFetch
}

enum NetworkConstants : String {
    case baseUrl = "https://irapps.github.io/wzpsolutions/tests/ios-custom-icons/IconsData.json"
}
