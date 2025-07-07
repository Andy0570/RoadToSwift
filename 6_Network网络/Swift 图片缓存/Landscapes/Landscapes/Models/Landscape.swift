//
//  Landscape.swift
//  Landscapes
//
//  Created by Bart Jacobs on 20/04/2021.
//

import Foundation

struct Landscape: Decodable {

    // MARK: - Types
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case title
        case imageUrl = "image_url"
        
    }
    
    // MARK: - Properties
    
    let title: String
    
    // MARK: -
    
    let imageUrl: URL
    
}
