//
//  Data.swift
//  Todoey
//
//  Created by Umakanta Sahoo on 29/12/18.
//  Copyright © 2018 MAGE. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age:Int = 0
}
