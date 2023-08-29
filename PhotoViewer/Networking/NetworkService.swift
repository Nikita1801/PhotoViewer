//
//  NetworkService.swift
//  PhotoViewer
//
//  Created by Никита Макаревич on 30.08.2023.
//

import Foundation
import Nuke

struct Keys {
    public static let apiKey = "-1xc7qe0LH0jZbvV8T5mpzhS4RWyC8EpsNnSBkIQAKg"
}

final class NetworkService {
    private let endpoint = "https://api.unsplash.com/photos/random?count=30&client_id=\(Keys.apiKey)"
    
    public func getPhotos() async throws -> [Photo] {
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
                
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Photo].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    public func configureCache() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        let pipeline = ImagePipeline {
          let dataCache = try? DataCache(name: "com.nikitaMakarevich.randomPhotos.datacache")
          dataCache?.sizeLimit = 200 * 1024 * 1024
          $0.dataCache = dataCache
        }
        ImagePipeline.shared = pipeline
    }
}

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown
    
    public var description: String {
        switch self {
        case .invalidURL:
            return "Looks like your URL is invalid"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid server data"
        case .unknown:
            return "Looks like something went wrong"
        }
    }
}
