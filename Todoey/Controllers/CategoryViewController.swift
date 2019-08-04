//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/30/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm() // initializing a new Realm instance
    
    // Results is an auto-updating container type in Realm returned from object queries, in this case, it contains a bunch of "Category" objects-- this means we don't need to "append" things to it anymore!
    //by using <Category>! - it force unwraps the Category objects and if it's "nil" it will cause app to crash
    
    var categories: Results<Category>?  // safer by using <Category>? , we make categories an optional
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
    }

    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if categoris is NOT nil, then return categories.count, otherwise return "1" -- "??" is called the nil coalescing operator
        return categories?.count ?? 1
    }
    
    // create a reusable cell and adds it to table at the index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
  
        return cell // so that it can be rendered on screen
    }
    
    //MARK: Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        // this will pull out all of the items inside our Realm that are of Category objects, specifying the Category type is "Category.self"
        
        categories = realm.objects(Category.self) // this is of a Realm datatype Results<Category>
        tableView.reloadData()
    }
    
    // MARK: Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
            }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    //MARK: TableView Delegate Methods
    // this will trigger when we select one of the cells (category) -- and we will want to trigger the segue that takes user from category to items
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            // selectedCategory is defined in TodoListViewController, will load up the items for that category when the category cell is selected
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            // what happens when user clicks the "Add" button
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new category"
            
        }
      
        present(alert, animated: true, completion: nil)

    }
}


