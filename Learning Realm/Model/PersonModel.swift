//
//  PersonModel.swift
//  Learning Realm
//
//  Created by Francisco De Freitas on 31/12/20.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
