//
//  Category.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

// Structs to get list of drinks
struct CategoryList: Codable {
    var categories: [Category]
    
    enum CodingKeys: String, CodingKey {
        case categories = "drinks"
    }
}

struct Category: Codable {
    var name: String?
 
    private enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}
