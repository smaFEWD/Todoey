//
//  ViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/16/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
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
        
    }
    
    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // use optional chaining, if todoItems is not nil, then return the count, otherwise, return 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // use optional chaining
        
        if let item  = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
//                    item.done = !item.done
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



// MARK: Search Bar Methods
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // read from context
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
////        print(searchBar.text!)
//
//        //to query CoreData, we need to use NSPredicate- which is a query language
//        // resources: https://academy.realm.io/posts/nspredicate-cheatsheet/
//        // resources: https://nshipster.com/nspredicate/
//        // [cd] makes it diacritic and case insensitive for the query search
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            // this has a default request that will fetch ALL items from the items stored
//            loadItems()
//
//            // dispatchQueue manages the distribution of items, prioritizing which items needs to be processed- and assigns the different projects to diff threads- so we are asking it to get the main thread
//            // which makes the keyboard disappear and the cursor will go away from the search input field
//            DispatchQueue.main.async {
//                // tell the searchBar to stop being the 'first responder', means no longer have the cursor - no longer actively waiting for user to enter search
//                searchBar.resignFirstResponder()
//
//            }
//
//        }
//    }
}
