//
//  ViewController.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableContacts: UITableView!
    private var favoriteContacts:[Contact]?
    private var showFavorite: Bool = false
    
    private func updateFavoriteArray() {
        favoriteContacts = Contacts.shared.value.filter({$0.favorite})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteArray()
        tableContacts.reloadData()
    }

    // Нельзя называть функции с большой буквы (нарушает CamleCase)
    @IBAction func FavoriteList(_ sender: UISegmentedControl) {
        
        self.showFavorite = sender.selectedSegmentIndex == 1
        self.tableContacts.reloadData()
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {

        let action = UIContextualAction(style: .destructive, title: "delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            var uuid: String = ""
            if self.showFavorite {
                uuid = self.favoriteContacts![indexPath.row].uuid
            } else {
                uuid = Contacts.shared.value[indexPath.row].uuid
            }
            
            if let index = Contacts.shared.value.firstIndex(where: {$0.uuid == uuid}){
                Contacts.shared.value.remove(at: index)
                self.updateFavoriteArray()
                self.tableContacts.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completionHandler(true)
        }
        return action
        
    }
    
}


// Все методы делегата таблицы вынес
// в отдельный extension, так более читаемо и логично
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFavorite {
            return favoriteContacts?.count ?? 0
        } else {
            return Contacts.shared.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
        var contact = Contacts.shared.value[indexPath.row]
        if showFavorite && (favoriteContacts?.count ?? 0)>0 {
            contact = favoriteContacts![indexPath.row]
        }
        cell.textLabel?.text = contact.firstName + " " + contact.dobleName
        if contact.favorite {
            cell.imageView?.image = UIImage(named: "star")
        } else {
            cell.imageView?.image = UIImage(named: "star1")
        }
        cell.imageView?.tintColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedContacs = Contacts.shared.value[indexPath.row]
        if showFavorite {
            selectedContacs = favoriteContacts![indexPath.row]
        }
        if let rename = storyboard?.instantiateViewController(identifier: "NewContact") as? NewContactViewController {
            rename.selectedContact = selectedContacs
            navigationController?.pushViewController(rename, animated: true)
        }
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
}

