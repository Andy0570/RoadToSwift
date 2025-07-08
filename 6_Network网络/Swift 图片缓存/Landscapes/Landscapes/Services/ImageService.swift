//
//  ImageService.swift
//  Landscapes
//
//  Created by huqilin on 2025/7/7.
//

import UIKit

final class ImageService {
    
    // MARK: - Public API
    
    func image(for url: URL, completion: @escaping(UIImage?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            // Helper
            var image: UIImage?
            
            defer {
                // Execute Handler on Main Thread
                DispatchQueue.main.async {
                    // Execute Handler
                    completion(image)
                }
            }
            
            if let data {
                // Create Image from Data
                image = UIImage(data: data)
            }
        }
        
        // Resume Data Task
        dataTask.resume()
        
        return dataTask
    }
}
