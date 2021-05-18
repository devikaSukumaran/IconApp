//
//  Icon.swift
//  IconApp
//
//  Created by Devika Sukumaran on 18/05/2021.
//

import Foundation

struct Icon : Codable {
    let title : String
    let subtitle : String
    let image : String
}

typealias Icons = [Icon]

struct IconData : Codable {
    let icons : Icons
}
