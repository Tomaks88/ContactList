//
//  NewContactViewController.swift
//  ContactList
//
//  Created by Максим Томилов on 10.11.2019.
//  Copyright © 2019 Tomily. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController {

    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var doubleNameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var favoriteCount: UISwitch!
    @IBOutlet weak var callPhone: UIButton!
    
    var saveButton: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    
    var selectedContact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSaveButton))
        // не забывай отделять фигурные скобки проблами
        if selectedContact != nil {
            firstNameText.text = selectedContact?.firstName
            doubleNameText.text = selectedContact?.dobleName
            phoneText.text = "\(selectedContact!.phone)"
            favoriteCount.isOn = selectedContact?.favorite ?? false
            editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditButton))
            self.navigationItem.setRightBarButton(editButton, animated: true)
        }else{ // и тут тоже
            self.navigationItem.setRightBarButton(saveButton, animated: true)
        }
    }
    
    // Методы жизненного цикла обычно наверху, под аутлетами
    // Конечно же если нет конструкторов, тогда они будут выше
    // методов жизненного цикла
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedContact != nil {
            enableTextFields(isEnable: false)
        }else{
            callPhone.isHidden = true
        }
    }
    
    private func enableTextFields(isEnable: Bool) {
        firstNameText.isEnabled = isEnable
        doubleNameText.isEnabled = isEnable
        phoneText.isEnabled = isEnable
        favoriteCount.isEnabled = isEnable
    }
    
    @objc func onSaveButton(_ sender: Any) {
        // Всё это можно сделать с помощью одного guard ... else
        // Иначе, если у тебя в блоке else лежит какая-то логика
        // То её придётся писать несколько раз и это не хорошо
//         guard let name1 = firstNameText.text else {return}
//            guard let name2 = doubleNameText.text else {return}
//            guard let phone1 = phoneText.text else {return}
//            guard let intPhone = Int(phone1) else {return}
        
        guard
            let firstName = firstNameText.text,     // name1 -> firstName
            let lastname = doubleNameText.text,    // name2 -> lastName
            let phone1 = phoneText.text,
            let intPhone = Int(phone1)
        else { return } // А тут лучше бы показывать ошибку пользователю, что инфа не заполнена
        
        if selectedContact == nil {
            // Немного отформатировал заполнение контакта
            let newContact = Contact(
                firstName: "\(firstNameText.text!)",
                dobleName: "\(doubleNameText.text!)",
                phone: intPhone,
                favorite: favoriteCount.isOn
            )
            Contacts.shared.value.append(newContact)
            navigationController?.popViewController(animated: true)
        } else {
            selectedContact?.firstName = firstName
            selectedContact?.dobleName = lastname
            selectedContact?.phone = intPhone
            selectedContact?.favorite = favoriteCount.isOn
            let uuid = self.selectedContact!.uuid
            if let index = Contacts.shared.value.firstIndex(where: {$0.uuid == uuid}){
                Contacts.shared.value[index] = selectedContact!
            }
            callPhone.isHidden = false
            self.navigationItem.setRightBarButton(editButton, animated: true)
        }
        }
    
    @objc func onEditButton(_ sender: Any){
        enableTextFields(isEnable: true)
        callPhone.isHidden = true
        self.navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    @IBAction func callPhoneContact(_ sender: Any) {
        guard let number = URL(string: "tel://+" + "\(selectedContact!.phone)") else { return }
        UIApplication.shared.open(number)
    }
    
}
