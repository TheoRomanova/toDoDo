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
import ChameleonFramework
import AVFoundation

class CategoryTVC: SwipeTVC {
    
    private var categoriesArray: Results<Category>?
    
    private let realm = try! Realm()
    
    private var player: AVAudioPlayer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(hexString: "BD83CE")

        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
        
        navBar.backgroundColor = UIColor(hexString: "BD83CE")
        navBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "DisneyPark", size: 40)!,
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ]
    }
    // MARK: - TableView datSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].title ?? "No Categories Added Yet"
        
        if let color = UIColor(hexString: categoriesArray?[indexPath.row].color ?? "C8B0FF") {
            cell.backgroundColor = color
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            cell.textLabel?.font = UIFont(name: "DisneyPark", size: 40)
        }
        
        return cell
    }
    
    //MARK: - Add New Category
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
      print("gsrbgsfgb")
        playSound(song: "add")
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.title = textField.text!
            newCategory.dateCreated = Date()
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
            self.playSound(song: "wasAdded")
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category here"
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
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
        playSound(song: "nextPage")
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.chosenCategory = categoriesArray?[indexPath.row]
        }
    }
    
    //MARK: - Delete Data From Swipe
    
    override func deleteAction(at indexPath: IndexPath) {
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
    //MARK: - AVFoundation
    
    func playSound(song: String) {
        let url = Bundle.main.url(forResource: song, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player?.play()
    }


}




