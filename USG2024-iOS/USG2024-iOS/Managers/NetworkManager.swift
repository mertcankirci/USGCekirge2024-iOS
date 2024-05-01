//
//  NetworkManager.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//return "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey/page-\(pageNumber).json"

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private var baseUrl: String = "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey/page-"
    var page: Int = 1
    private init() {}
    
    func getCities(completed: @escaping(Result<NetworkResult, USGError>) -> Void) {
        let endpoint = baseUrl + "\(page).json"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToRequestFromURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NetworkResult.self, from: data)
                
                completed(.success(result))
            } catch {
                completed(.failure(.invalidData))
            }
            
        }
        
        task.resume()
    }
}
