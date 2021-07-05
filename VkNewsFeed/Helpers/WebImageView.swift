//
//  WebImageView.swift
//  VkNewsFeed
//
//  Created by vladislavpanev on 02.06.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    func set(imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)){
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse){
        guard let responseUrl = response.url else { return }
        let cr = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cr, for: URLRequest(url: responseUrl))
    }
}
