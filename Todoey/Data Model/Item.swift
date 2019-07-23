//
//  Item.swift
//  Todoey
//
//  Created by Sandi Ma on 7/17/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import Foundation

// Coddable means that this Item class conforms to both the Encodable and Decodable protocols

class Item: Codable {
    var title : String = ""
    var done: Bool = false 
}
