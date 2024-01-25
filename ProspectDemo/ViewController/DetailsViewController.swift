//
//  DetailsViewController.swift
//  ProspectDemo
//
//  Created by iMac on 27/08/22.
//

import UIKit
import Toast_Swift
import OneSignalFramework

class DetailsViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtOneSignalID: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCopyId: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldBoarder(txtFirstName)
        setTextFieldBoarder(txtOneSignalID)
        txtFirstName.text = UserDefaults.standard.string(forKey: "_Defaults_First_Name")
        
        let userId = OneSignal.User.pushSubscription.id ?? ""
        txtOneSignalID.text = userId
        print("OneSignal User ID: \(userId)")
        
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 6
    }
    
    func setTextFieldBoarder(_ txt: UITextField) {
        txt.clipsToBounds = true
        txt.layer.cornerRadius = 8
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.addPadding(.left(8))
        if txt == txtOneSignalID {
            txt.addPadding(.right(44))
        } else {
            txt.addPadding(.right(8))
        }
        
        txt.delegate = self
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let stFirstName = txtFirstName.text?.trim() ?? ""
        let name = UserDefaults.standard.string(forKey: "_Defaults_First_Name") ?? ""
        if name != stFirstName {
            OneSignal.User.addTags(["firstName": stFirstName])
        }
        UserDefaults.standard.set(stFirstName, forKey: "_Defaults_First_Name")
        self.view.makeToast("Updated successfully.")
        
        if let email = emailTextField.text, !email.isEmpty,
           let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
            
            // Sending data to OneSignal
            OneSignal.User.addEmail(email)
            OneSignal.User.addSms(phoneNumber)
        } else {
            // Alert user to fill both fields
            let alert = UIAlertController(title: "Error", message: "Please enter both email and phone number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func onCopyIdClick(_ sender: Any) {
        UIPasteboard.general.string = txtOneSignalID.text
        self.view.makeToast("OneSignal Id copied.")
    }
    
    
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtOneSignalID {
            txtFirstName.resignFirstResponder()
            UIPasteboard.general.string = textField.text ?? ""
            return false
        }
        return true
    }
}
