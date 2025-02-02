//
//  Picture.swift
//  Milestone Projects 10-12
//
//  Created by Kristina Kostenko on 01.10.2024.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
