//
//  SwipeTVC.swift
//  toDoDO
//
//  Created by Theodora on 3/24/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import UIKit
import SwipeCellKit
import AVFoundation

class SwipeTVC: UITableViewController, SwipeTableViewCellDelegate {
    
    private var player: AVAudioPlayer?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "") { action, indexPath in
            self.deleteAction(at: indexPath)
        }
        
        playSound()
        //        deleteAction.image = UIImage(named: "delete-icon")?.withTintColor(.flatWhiteDark())
        //        deleteAction.title = ""
        deleteAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.1717308096, blue: 0.3966416737, alpha: 1)
        deleteAction.font = UIFont(name: "DisneyPark", size: 30)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteAction(at indexPath: IndexPath) {
    }

    private func playSound() {
        let url = Bundle.main.url(forResource: "delete", withExtension: "wav")        
        player = try! AVAudioPlayer(contentsOf: url!)
        player?.play()
    }

}
