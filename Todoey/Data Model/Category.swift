//
//  Category.swift
//  Todoey
//
//  Created by Sandi Ma on 7/31/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    // dynamic means we can monitor for changes while the app is running, monitor for runtime errors
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    // categories point to items and back, they have relationships
    // List datatype comes from Realm
    let items = List<Item>() // a list of item objects
}


// examples of similar syntax
//let array = Array<Int> = [1,2,3]
//let array = Array<Int>() // empty array of integers
