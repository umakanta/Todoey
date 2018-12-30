//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Umakanta Sahoo on 28/12/18.
//  Copyright © 2018 MAGE. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added yet"
        return cell
    }
    

    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alertVC = UIAlertController(title: "Add Category.", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
           
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alertVC.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category..."
            textField = alertTextField
        }
        
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error in saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexpPath: IndexPath) {
        
        if let categoryToDelete = categories?[indexpPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            }
            catch {
                print("Error deleting category...: \(error)")
            }
        }
    }
}


