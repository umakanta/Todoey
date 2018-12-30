//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Umakanta Sahoo on 30/12/18.
//  Copyright © 2018 MAGE. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    func updateModel(at indexpPath: IndexPath) {
        print("Update model in superclass")
    }
}

//MARK: - Swipe Cell Delegate Methods
extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (swipeAction, indexPath) in
            //Handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
        }
        //Customize the action appearance
        deleteAction.image = UIImage(named: "Trash_Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        
        return options
        
    }
    
   
    
}
