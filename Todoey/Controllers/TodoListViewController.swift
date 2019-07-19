//
//  ViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]() // turning this array into Item() objects that was created in Data Model
    
    //creating only a path to the Items.plist - making it a global variable
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // b/c it's an array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Render the list from the persisted data in User Defaults
        
    print(dataFilePath)

        
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
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
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
        
//  before the refactored code above..it was like this
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
        
        saveItems() // saved to the Encoder Items.plist file
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
            self.saveItems() // saved to the Encoder Items.plist file

            
            
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
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print ("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
}

