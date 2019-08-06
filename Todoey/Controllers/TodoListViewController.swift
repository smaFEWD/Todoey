//
//  ViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>? // a Realm datatype - Results container containing a bunch of Items
    // creating a new instance of Realm
    
    var realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            //this is loading items (only when there is a selected Category)
            loadItems()
        }
    }
    
    //creating only a path to the Items.plist - making it a global variable
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // b/c it's an array
    
    // accessing a SINGLETON - UIApplication shared, and accessing it's delegate property, which is AppDelegate, and tapping into it's persistentContainer and viewContext properties
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
    }
    
    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // use optional chaining, if todoItems is not nil, then return the count, otherwise, return 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // use optional chaining
        
        if let item  = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            // if the selectedCategory color is NOT nil (? means..)  then move foward and darken the cell
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell // so that it can be rendered on screen
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item) - prefer to NOT delete but instead use the checkmark below for done
                    item.done = !item.done
                }
            }
            catch
            {
                    print("Error saving done status, \(error)")
            }
            
        }
            tableView.reloadData()
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default)
        {
            (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert

            if let currentCategory = self.selectedCategory
            {
                // after unwrapping the self.selectedCategory, then we will "save" to Realm using realm.write
                do
                {
                    try self.realm.write
                    {
                        let newItem = Item() // initializing a new object from Item class
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()//  new instance of Date - which is the current date/time
                        //append the new items to the list
                        currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                    print("Error saving new items, \(error)")
                }
                self.tableView.reloadData()
            }
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

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    // MARK: Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}


// MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // now sorting by title and also by the date created 
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // this has a default request that will fetch ALL items from the items stored
            loadItems()

            // dispatchQueue manages the distribution of items, prioritizing which items needs to be processed- and assigns the different projects to diff threads- so we are asking it to get the main thread
            // which makes the keyboard disappear and the cursor will go away from the search input field
            DispatchQueue.main.async {
                // tell the searchBar to stop being the 'first responder', means no longer have the cursor - no longer actively waiting for user to enter search
                searchBar.resignFirstResponder()

            }

        }
    }
}
