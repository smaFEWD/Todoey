//
//  Item.swift
//  Todoey
//
//  Created by Sandi Ma on 7/17/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title : String = ""
    var done: Bool = false 
}
