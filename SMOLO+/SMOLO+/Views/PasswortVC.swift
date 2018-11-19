//
//  PasswortVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit
import Firebase

class PasswortVC: UIViewController, UITextFieldDelegate {
    
    // VARS
    var Pin = String()
    //OUTLETS
    
    @IBOutlet weak var altesPW: UITextField!
    
    @IBOutlet weak var neuesPW1: UITextField!
    
    @IBOutlet weak var neuesPW2: UITextField!
    
    @IBOutlet weak var pin: UITextField!
    
    //ACTIONS
    
    @IBAction func speichernPW(_ sender: Any) {
        let currentuser = Auth.auth().currentUser
        if currentuser != nil {
            if neuesPW1.text == neuesPW2.text && neuesPW1.text != "" && neuesPW2.text != "" {
                
                if currentuser?.email != nil {
                    Auth.auth().fetchProviders(forEmail: (currentuser?.email)!) { (loginProvider, error) in
                        if error != nil {
                            self.alert(title: "Feler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                        } else {
                            if loginProvider != nil && loginProvider![0] == "password"{
                                currentuser?.updatePassword(to: self.neuesPW1.text!, completion: { (error) in
                                    if error != nil {
                                        self.alert(title: "Fehler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                                    } else {
                                        let email = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email!)!, password: self.altesPW.text!)
                                        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: email, completion: { (result, error) in
                                            if error != nil {
                                                self.getPin()
                                                if self.pin.text == self.Pin {
                                                    self.alertlogout(title: "Erfolgreich", message: "Dein Passwort wurde aktualisiert. Bitte melde dich erneut an", actiontitle: "Ok")}
                                                else {
                                                    self.alert(title: "Fehler", message: "Der eingegebene Pin ist ungültig", actiontitle: "Ok")
                                                }
                                                
                                            } else {
                                                self.alert(title: "Feler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                                            }  })}  })
                            } else {
                                self.alert(title: "Fehler", message: "Du hast dich bisher über Facebook eingeloggt. Wenn du dein Passwort ändern möchtest, musst du dies auf Facebook tun.", actiontitle: "Ok") }  } }
                } else {
                    alert(title: "Feler", message: "Deine Email-Adresse ist ungültig. Bitte informeire info@madapp.de", actiontitle: "Ok")
                } }
            else {
                alert(title: "Fehler", message: "Das Passwörter stimmen nicht überein", actiontitle: "Ok")
            }
        } else {
            alert(title: "Fehler", message: "Du bist scheinbar kein autorisierter Nutzer. Bitte informiere info@madapp.de", actiontitle: "Ok") } }
    
    @IBAction func abbrechenPW(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // FUNCS
    
    func getPin(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Kellner").child((Auth.auth().currentUser?.uid)!).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let KellnerInfo = KellnerInfos(dictionary: dictionary)
                self.Pin = KellnerInfo.Pin!
            
            }
            
        }, withCancel: nil)
    }
    
    func alert(title: String, message: String, actiontitle: String) {
        let alertFehlgeschlagen = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertFehlgeschlagen.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alertFehlgeschlagen, animated: true, completion: nil)
    }
    
    func alertlogout(title: String, message: String, actiontitle: String) {
        let alertLogoutErfolgreich = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertLogoutErfolgreich.addAction(UIAlertAction(title: actiontitle, style: .default, handler: { (UIAlertAction) in
            if Auth.auth().currentUser?.uid != nil {
                do
                { try Auth.auth().signOut()
                    }
                catch let error as NSError{
                    print(error.localizedDescription) } }
            self.performSegue(withIdentifier: "unwind", sender: self)
        }))
        self.present(alertLogoutErfolgreich, animated: true, completion: nil)
    }
    
    // TEXTFIELD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            altesPW.resignFirstResponder()
            neuesPW2.resignFirstResponder()
            neuesPW1.resignFirstResponder()
            pin.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Passwort ändern"

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        altesPW.delegate = self
        neuesPW2.delegate = self
        neuesPW1.delegate = self
        pin.delegate = self
        altesPW.keyboardAppearance = UIKeyboardAppearance.dark
        neuesPW2.keyboardAppearance = UIKeyboardAppearance.dark
        neuesPW1.keyboardAppearance = UIKeyboardAppearance.dark
        pin.keyboardType = UIKeyboardType.numberPad
        pin.keyboardAppearance = UIKeyboardAppearance.dark
        
    }
}
