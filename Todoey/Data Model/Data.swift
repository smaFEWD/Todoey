//
//  Data.swift
//  Todoey
//
//  Created by Sandi Ma on 7/31/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import Foundation
import RealmSwift

// since we are using Realm, we need to use "dynamic" which marks it as a dynamic dispatch instead of a static dispatch-- allows that property name to be monitored by Realm, for changes, at run time, but it's objective C, so that is the below syntax when declaring a property with Realm 

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
