//
//  NetworkDataFetcher.swift
//  VkNewsFeed
//
//  Created by vladislavpanev on 23.05.2021.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters" : "post, photo"]
        networking.request(from: API.feedNews, params: params) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return response
    }
}
