//
//  ViewController.swift
//  Todoey
//
//  Created by Umakanta Sahoo on 13/12/18.
//  Copyright © 2018 MAGE. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory: Category? {
        didSet {
    
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let t = selectedCategory?.name {
            self.title = "\(t): Items"
        }
        

    }


    //MARK: - Tableview DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType =  item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items added"
        }
        
        
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
                }
            }
            catch {
                print("Error in Updating Item \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add Action Method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (alertAction) in
            
            if let currentcategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = (textField.text?.isEmpty)! ? "New Item" : textField.text!
                        currentcategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error in saving Item \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(item: Item) {

        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch {
            print("Error in saving Item \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Cell
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }
            catch {
                print("Error in Deleting Item \(error)")
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }


    }
}

