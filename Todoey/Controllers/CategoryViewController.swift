//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandi Ma on 7/30/19.
//  Copyright © 2019 Sandi Ma. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // create a reusable cell and adds it to table at the index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // the "name" attribute was added to the Category Entity, and we need to set the text property of the cell.textLabel
        cell.textLabel?.text = categories[indexPath.row].name
        return cell // so that it can be rendered on screen
    }
    
    //MARK: Data Manipulation Methods
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        // need to read data from our context
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            // what happens when user clicks the "Add" button
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new category"
            
        }
      
        present(alert, animated: true, completion: nil)
        
    }
    
   
    
    
}
