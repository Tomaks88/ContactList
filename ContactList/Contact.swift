//
//  Contact.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation

// Добавил немного отступов
struct Contact: Codable {
    
    let uuid: String = UUID().uuidString
    var firstName: String
    var dobleName: String
    var phone: Int
    var favorite: Bool = false
    
}
