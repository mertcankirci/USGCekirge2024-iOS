//
//  USGError.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import Foundation

enum USGError: String, Error {
    case unableToRequestFromURL = "Unable to request right now. Please try again."
    case unableToComplete = "Unable to complete request please check your internet connection."
    case invalidResponse = "Invalid response from the server , please try again."
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToFavorite = "There was an error. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
    case invalidWebsiteURL = "The website URL is not available right now. Please try again."
}
