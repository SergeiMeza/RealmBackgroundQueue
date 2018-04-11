//
//  AppDelegate.swift
//  RealmBackgroundQueue
//
//  Created by Jeany Sergei Meza Rodriguez on 4/11/30 H.
//  Copyright © 30 Heisei Amigo. All rights reserved.
//

import UIKit
import RealmSwift

let realmQueue = DispatchQueue.init(label: "Realm")

extension Notification.Name {
    static var newUsersAdded = Notification.Name.init("NewUsersAdded")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        realmQueue.async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    for i in 1...100_000 {
                        let user = DBUser()
                        user.objectId = "\(i)"
                        user.name = "NAME\(i)"
                        user.age = "AGE\(i)"
                        realm.add(user, update: true)
                    }
                }
                NotificationCenter.default.post(name: .newUsersAdded, object: nil)
            }
        }
        
        let vc = ViewController()
        let nvc = UINavigationController.init(rootViewController: vc)
        nvc.title = "Realm UI"
        let tbc = UITabBarController.init()
        tbc.viewControllers = [nvc]
        window?.rootViewController = tbc
        
        return true
    }
}

@objcMembers class DBUser: Object {
    
    dynamic var objectId = ""
    dynamic var name = ""
    dynamic var age = ""
    
    override static func primaryKey() -> String? {
        return "objectId"
    }
}

struct User {
    let objectId: String
    let name: String
    let age: String
    
    init(objectId: String, name: String, age: String) {
        self.objectId = objectId
        self.name = name
        self.age = age
    }
}
