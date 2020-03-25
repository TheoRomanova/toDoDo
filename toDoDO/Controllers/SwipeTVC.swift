//
//  SwipeTVC.swift
//  toDoDO
//
//  Created by Theodora on 3/24/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTVC: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
        
         tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.deleteAction(at: indexPath)
        }
        // customize the action appearanceΩ
        deleteAction.image = UIImage(named: "delete-icon")?.withTintColor(.white)
        deleteAction.title = ""
        deleteAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.5098180579, blue: 0.9686274529, alpha: 1)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteAction(at indexPath: IndexPath) {
    }
}
