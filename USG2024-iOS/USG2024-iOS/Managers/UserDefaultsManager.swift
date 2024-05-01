//
//  UserDefaultsManager.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 29.04.2024.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func saveToUserDefaults(favoriteUniversities: [University]) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(favoriteUniversities)
            defaults.set(data, forKey: "favoriteUniversities")
        } catch {
            #if DEBUG
            print("Error saving favorite universities: \(error)")
            #endif
        }
    }
    
    func addUniversityToFavorites(_ university: University) throws {
        var favoriteUniversities = loadFavoriteUniversities()
        if !favoriteUniversities.contains(university) {
            favoriteUniversities.append(university)
            saveToUserDefaults(favoriteUniversities: favoriteUniversities)
        } else {
            throw USGError.alreadyInFavorites
        }
    }
    
    func removeUniversityFromFavorites(_ university: University) {
        var favoriteUniversities = loadFavoriteUniversities()
        if let index = favoriteUniversities.firstIndex(of: university) {
            favoriteUniversities.remove(at: index)
            saveToUserDefaults(favoriteUniversities: favoriteUniversities)
        }
    }
    
    func loadFavoriteUniversities() -> [University] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "favoriteUniversities") {
            let decoder = JSONDecoder()
            if let favoriteUniversities = try? decoder.decode([University].self, from: data) {
                return favoriteUniversities
            }
        }
        return []
    }
}
