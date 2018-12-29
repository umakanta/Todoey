//
//  Item.swift
//  
//
//  Created by Umakanta Sahoo on 29/12/18.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date() 
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
