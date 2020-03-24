//
//  Item.swift
//  toDoDO
//
//  Created by Theodora on 3/22/20.
//  Copyright © 2020 Feodora Andryieuskaya. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? //т.к. это класс, нужен иниц
   
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
