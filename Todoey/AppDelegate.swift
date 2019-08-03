//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
      // print out where the location of data is stored in Realm
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        

        // initializing our Realm DB
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, (error)")
        }
        return true
    }

}


