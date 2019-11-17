//
//  API.swift
//  ContactList
//
//  Created by Максим Томилов on 14.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

struct ContactsStorage: Codable {
    let contacts : [Contact]
}

enum API {

    static var identifier: String { "tomily" }
    static var baseURL: String {
        "https://ios-napoleonit.firebaseio.com/data/\(identifier)/"
    }
    static var storageName: String { "contacts" }

    static func loadContacts(completion: @escaping ([Contact]?, NSError?) -> Void) {
        let url = URL(string: baseURL + ".json")!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
                else {
                    completion(nil, error as NSError?)
                    return
            }
            let contactsJson = json[storageName] as! JSON
            
            var contacts = [Contact]()
            for (_, data) in contactsJson {
                let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
                let decodeResult = try? JSONDecoder().decode(Contact.self, from: jsonData!)
                if decodeResult != nil {
                    contacts.append(decodeResult!)
                }
            }
            completion(contacts, nil)
            
        }
        task.resume()
    }
    
    static func createContact(newContact: Contact, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/\(storageName)/\(newContact.uuid)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(newContact)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(error == nil)
            }
            task.resume()
    }
    
    static func editContact(contactID: String, contact: Contact, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/\(storageName)/\(contactID)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONEncoder().encode(contact)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
    static func deleteContact(contactID: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: baseURL + "/\(storageName)/\(contactID)/.json")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }
        task.resume()
    }
}
