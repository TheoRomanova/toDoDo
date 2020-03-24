//
//  Category.swift
//  toDoDO
//
//  Created by Theodora on 3/22/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    
    
    let items = List<Item>()
}
