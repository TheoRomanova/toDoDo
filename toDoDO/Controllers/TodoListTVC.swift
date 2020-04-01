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

class TodoListTVC: SwipeTVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var itemsArray: Results<Item>?
    
    private let realm = try! Realm()
    
    private var player: AVAudioPlayer?
    
    var chosenCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableColor = chosenCategory?.color {
            tableView.backgroundColor = UIColor(hexString: tableColor)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorCategory = chosenCategory?.color {
            
            title = chosenCategory?.title
            
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
            
            if let navBarColor = UIColor(hexString: colorCategory) {
                
                navBar.backgroundColor = navBarColor
                navBar.largeTitleTextAttributes = [
                    NSAttributedString.Key.font: UIFont(name: "DisneyPark", size: 50)!,
                    NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)
                ]
                
                searchBar.barTintColor = navBarColor
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemsArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            if let color = UIColor(hexString: chosenCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemsArray!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
                cell.textLabel?.font = UIFont(name: "DisneyPark", size: 30)
            }
        }
        
        return cell
    }
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playSound(song: "bool")
        
        if let item = itemsArray?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    //MARK: - Add New Items
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        playSound(song: "add")
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)       
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            if let mainCategory = self.chosenCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        mainCategory.items.append(newItem)
                        self.playSound(song: "wasAdded")
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Item here"
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItems() {
        itemsArray = chosenCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func deleteAction(at indexPath: IndexPath) {
        if let categoryForDeletion = itemsArray?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
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

//MARK: - UISearchBarDelegate Methods

extension TodoListTVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsArray = itemsArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
}
