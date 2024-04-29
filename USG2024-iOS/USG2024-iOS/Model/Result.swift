//
//  Result.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import Foundation

struct NetworkResult: Codable {
    let currentPage, totalPage, total, itemPerPage: Int
    let pageSize: Int
    let data: [City]
}
