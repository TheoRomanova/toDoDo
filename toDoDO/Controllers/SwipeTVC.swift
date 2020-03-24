//
//  SwipeTVC.swift
//  toDoDO
//
//  Created by Theodora on 3/24/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import UIKit

class SwipeTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
