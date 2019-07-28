//
//  ViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]() // turning this array into Item() objects that was created in Data Model
    
    //creating only a path to the Items.plist - making it a global variable
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // b/c it's an array
    
    // need the object of the AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//   this is loading items from the itemArray
        loadItems()
        
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

        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
        // this updates the DONE property
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // this removes an item at a particular index (DELETE) - the order of the 2 lines of code matters
        
        context.delete(itemArray[indexPath.row]) // removes the item from the context before saving it using saveItems()  -- this part needs to come first before you attempt to remove it from the array
        
        itemArray.remove(at: indexPath.row) // removes the item from current array

        // after updating the DONE property, you are now commiting the changes by this saveItems() function
        saveItems() // saved to DB (commiting those changes) after it's been placed in context
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
    
    // MARK - Model Manipulation Methods
    //no longer using the encoder since we are using CoreData (not saving to a pList)
    func saveItems() {
        do {
        // context is defined as a global variable at the beginning of the file
           try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        // must specify the output as array
        // broad request, asking for everything back from db
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // then fetching what is stored in the db through our context, and placing it into the itemArray to load up onto the screen
           itemArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}
