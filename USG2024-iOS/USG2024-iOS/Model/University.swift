//
//  University.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import Foundation


struct University: Codable, Hashable {
    let name, phone, fax: String
    let website: String
    let email, adress, rector: String
}
