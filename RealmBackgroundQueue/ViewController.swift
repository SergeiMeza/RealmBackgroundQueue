//
//  ViewController.swift
//  RealmBackgroundQueue
//
//  Created by Jeany Sergei Meza Rodriguez on 4/11/30 H.
//  Copyright © 30 Heisei Amigo. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    var items =  [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        title = "Realm UI"
        tableView.register(RealmCell.self, forCellReuseIdentifier: String.init(describing: RealmCell.self))
        tableView.rowHeight = 50
        tableView.tableFooterView = nil
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItems), name: .newUsersAdded, object: nil)
        
        reloadItems()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newUsersAdded, object: nil)
    }
    
    @objc func reloadItems() {
        DispatchQueue.init(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                let items = realm.objects(DBUser.self)
                let minIndex = min(20, items.count)
                for i in 0...minIndex-1 {
                    let item = items[i]
                    let user = User.init(objectId: item.objectId, name: item.name, age: item.age)
                    self.items.append(user)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: RealmCell.self), for: indexPath) as! RealmCell
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.age
        return cell
    }
}

class RealmCell: UITableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.text = "hello world"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        contentView.backgroundColor = .white
    }
    
}
