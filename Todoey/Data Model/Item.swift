//
//  Item.swift
//  Todoey
//
//  Created by Sandi Ma on 7/31/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //defining the inverse relationship of Items to Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
