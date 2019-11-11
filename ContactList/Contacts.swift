//
//  Contacts.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation
class Contacts{
    
    static let shared = Contacts()
    let userDefaults: UserDefaults = UserDefaults.standard
    
    var value: [Contact] = [Contact(firstName: "tom", dobleName: "hardy", phone: 123141), Contact(firstName: "david", dobleName: "beckham", phone: 5434645, favorite: true),Contact(firstName: "kanya", dobleName: "west", phone: 87978),Contact(firstName: "zach", dobleName: "braff", phone: 09786, favorite: true),Contact(firstName: "will", dobleName: "smith", phone: 8375940),Contact(firstName: "tom", dobleName: "cruise", phone: 87978),Contact(firstName: "tom", dobleName: "hanks", phone: 87978, favorite: true)]{
        didSet{
            let data = try? JSONEncoder().encode(self.value)
            userDefaults.setValue(data, forKey: "saveContacts")
        }
    }
    init() {
        let loadData = userDefaults.data(forKey: "saveContacts")
        if loadData != nil {
            let decodeResult = try? JSONDecoder().decode([Contact].self, from: loadData!)
            if decodeResult != nil && decodeResult!.count > 0 {
                value.removeAll()
                value = decodeResult!
            }
        }
        
    }
    
}
