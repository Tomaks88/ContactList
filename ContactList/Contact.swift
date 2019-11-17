//
//  Contact.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation


struct Contact: Codable {
    
    private(set) var uuid: String = UUID().uuidString
    var firstName: String
    var dobleName: String
    var phone: Int
    var favorite: Bool = false
    
}
