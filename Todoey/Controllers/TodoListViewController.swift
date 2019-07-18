//
//  ViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
//    var itemArray = ["Call Kadir", "Buy Onions", "Go to class" ]
    // creating a new object (defaults) that is from User Defaults which stores key/value pairs in your database persistently across your app.
    let defaults = UserDefaults.standard
    
  
    var itemArray = [Item]() // turning this array into Item() objects that was created in Data Model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Render the list from the persisted data in User Defaults
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemArray = items
//        }
        
        // using the Item() object created in the Data Model so that we can assign a property (done/not-done) to each item, to avoid the checkmark from getting reused on a cell arbitrarily. Fixing this bug
        let newItem = Item()
        newItem.title = "Call Kadir"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go to Class"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item  = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData() // to show the checkmarks when the item has changed to DONE, forces the tableView to call the method "cellForRowAt" method again.
      

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // user defaults that persist in key value pair are seen in the plist and we pull out that array of objects from "ToDoListArray" 
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            // scope of alertTextField is only inside this closure
            alertTextField.placeholder = "Create new item"
            //scope of textField is larger, and within the entire addButtonPressed
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

