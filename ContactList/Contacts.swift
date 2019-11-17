//
//  Contacts.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation

class Contacts {
    
    static let shared = Contacts()
    let userDefaults: UserDefaults = UserDefaults.standard
    var value: [Contact] = []
    }
    

