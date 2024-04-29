//
//  City.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import Foundation


struct City: Codable, Hashable {
    let id: Int
    let province: String
    let universities: [University]
}
