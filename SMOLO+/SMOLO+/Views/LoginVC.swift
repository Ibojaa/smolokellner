//
//  ViewController.swift
//  SMOLO+
//
//  Created by Alper Maraz on 14.09.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController, UITextFieldDelegate {

    
    // VARS
    
    var kellnerID = String()
    var barname = String()
    
    // OUTLETS
    @IBOutlet weak var KellnerIdTextfield: UITextField!
    
    @IBOutlet weak var PasswortTextfield: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    
    
    @IBAction func LoginTapped(_ sender: Any) {
        
        if self.KellnerIdTextfield.text == "" || self.PasswortTextfield.text == "" {
            
            let alertController = UIAlertController(title: "Fehler", message: "Bitte E-Mail und Passwort eingeben.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.KellnerIdTextfield.text!, password: self.PasswortTextfield.text!) { (user, error) in

            if error == nil {
                    var ref: DatabaseReference?
                    ref = Database.database().reference()
                    ref?.child("Kellner").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                            self.kellnerID = (Auth.auth().currentUser?.uid)!
                            
                            self.segueToKellnerVC(KellnerID: self.kellnerID)
                        } else {
                            
                            if Auth.auth().currentUser?.uid != nil {
                                do
                                { try Auth.auth().signOut()            }
                                catch let error as NSError
                                {
                                    print(error.localizedDescription) }
                            }
                            print("kein Kellner Login")
                        }
                    }, withCancel: nil)
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
}
    
    func segueToKellnerVC(KellnerID: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Kellner").child(KellnerID).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let KellnerInfo = KellnerInfos(dictionary: dictionary)
                self.barname = KellnerInfo.Barname!
                self.performSegue(withIdentifier: "kellnerLoggedIn", sender: self)
            }
            
        }, withCancel: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kellnerLoggedIn" {
            
            let KTBC = segue.destination as! KellnerTBC
            let KVC = KTBC.viewControllers![0] as! KellnerVC
            KVC.KellnerID = (Auth.auth().currentUser?.uid)!
            KVC.Barname = barname
            let KACV = KTBC.viewControllers![1] as! KellnerAngenommenVC
            KACV.KellnerID = (Auth.auth().currentUser?.uid)!
            KACV.Barname = barname
            let KABCV = KTBC.viewControllers![2] as! KellnerAlleBestellungenVC
            KABCV.KellnerID = (Auth.auth().currentUser?.uid)!
            KABCV.Barname = barname
            let EVC = KTBC.viewControllers![3] as! EinstellungenVC
            EVC.KellnerID = (Auth.auth().currentUser?.uid)!
            EVC.Barname = barname
            
//            let PVVC = KTBC.viewControllers![3] as! ProdukteVC
//            PVVC.KellnerID = (Auth.auth().currentUser?.uid)!
//            PVVC.Barname = barname
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            PasswortTextfield.resignFirstResponder()
            KellnerIdTextfield.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

        KellnerIdTextfield.text = "i.akcam@gmx.de"
        PasswortTextfield.text = "123456"
        KellnerIdTextfield.delegate = self
        PasswortTextfield.delegate = self
        KellnerIdTextfield.keyboardAppearance = UIKeyboardAppearance.dark
        PasswortTextfield.keyboardAppearance = UIKeyboardAppearance.dark
        Auth.auth().languageCode = "de"
        LoginButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

