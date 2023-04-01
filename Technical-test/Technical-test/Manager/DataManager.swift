//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

enum DataManagerError: Error {
    case noData, parsingError
    
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data in response"
        case .parsingError:
            return "Data parsing error"
        }
    }
}

class DataManager {
    
    static private let favoritesURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("favorites.json")
    
    private var favorites = Set<String>()

    init() {
        if let url = DataManager.favoritesURL,
           let favoritesData = try? Data(contentsOf: url),
           let favoritesArray = try? JSONDecoder().decode([String].self, from: favoritesData) {
            favorites = Set(favoritesArray)
        }
    }
    
    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    

    func fetchQuotes(completionHandler: @escaping ([Quote], Error?) -> ()) {
        guard let url = URL(string: Self.path) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else {
                completionHandler([], nil)
                return
            }
            guard let data = data else {
                guard let error = error else {
                    completionHandler([], DataManagerError.noData)
                    return
                }
                completionHandler([], error)
                return
            }
            var quotes = [Quote]()
            do {
                quotes = try JSONDecoder().decode([Quote].self, from: data)
            } catch {
                completionHandler([], DataManagerError.parsingError)
            }
            completionHandler(quotes, nil)
        }.resume()
    }
    
    func isFavorite(quote: Quote) -> Bool {
        guard let name = quote.name else { return false }
        return favorites.contains(name)
    }

    func toggleFavorites(quote: Quote) {
        guard let name = quote.name else { return }
        if favorites.contains(name) {
            favorites.remove(name)
        } else {
            favorites.insert(name)
        }
        if let url = DataManager.favoritesURL,
           let favoritesData = try? JSONEncoder().encode(Array(favorites)) {
            try? favoritesData.write(to: url)
        }
    }
}
