//
//  TableViewController.swift
//  toDoDO
//
//  Created by Theodora on 3/22/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTVC: SwipeTVC {

    var categoriesArray: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - TableView datSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let category = categoriesArray?[indexPath.row] {
            cell.textLabel?.text = category.title
        }
        return cell
    }
    
    //MARK: - Add New Category
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.title = textField.text!
            newCategory.dateCreated = Date()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category here"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Save category error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
      
        categoriesArray = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: false) //пряи добавлении каждой единцы срабатывает 
        tableView.reloadData()
        
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListTVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.chosenCategory = categoriesArray?[indexPath.row]
        }
    }
}

     // MARK: - SwipeTableViewCellDelegate Methods

extension CategoryTVC: SwipeTableViewCellDelegate {

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
      guard orientation == .right else { return nil }

      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      
        if let categoryForDeletion = self.categoriesArray?[indexPath.row] {
        do {
            try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
        } catch {
            print("Error deleting category \(error)")
        }
      }
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
}
