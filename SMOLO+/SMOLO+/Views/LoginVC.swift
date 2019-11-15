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
    
    @IBOutlet var pwVergessenView: UIView!
    
    @IBOutlet weak var pwTextfield: UITextField!
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    // ACTIONS
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
    
    
    @IBAction func pwVergessenTapped(_ sender: Any) {
        self.view.addSubview(visualEffect)
        visualEffect.center = self.view.center
        visualEffect.bounds.size = self.view.bounds.size
        self.view.addSubview(pwVergessenView)
        pwVergessenView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        pwVergessenView.center = self.view.center
        pwVergessenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        pwVergessenView.alpha = 0
        pwTextfield.becomeFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.pwVergessenView.alpha = 1
            self.pwVergessenView.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func pwReset(_ sender: Any) {
        Auth.auth().fetchProviders(forEmail: pwTextfield.text!) { (loginProvider, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Fehler", message: "Es ist ein Fehler passiert. \(String(describing: error?.localizedDescription ?? "unbekanterfehler"))", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)            } else {
                
                if loginProvider != nil && loginProvider![0] == "password" {
                    Auth.auth().sendPasswordReset(withEmail: self.pwTextfield.text!) { (error) in
                        if error != nil {
                            
                            self.alert(title: "Fehler", message: "\(String(describing: error?.localizedDescription))", actiontitle: "OK")
                            
                        } else {
                            self.animateOutPW()
                            }
                    }} else {
                    self.alert(title: "Fehler", message: "Diese Email existiert nicht", actiontitle: "OK")
                }
                
            }
            
        }
    }
    // FUNCS
    func animateOutPW(){
        pwTextfield.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.pwVergessenView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.pwVergessenView.alpha = 0
        }) { (sucess:Bool) in
            self.pwVergessenView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == pwTextfield {
            animateOutPW()
        }
        
        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kellnerLoggedIn" {
            
            
            let KTBC = segue.destination as! KellnerTBC
                
                //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kellnertbc") as! KellnerTBC
                
            KTBC.Barname = barname
            KTBC.KellnerID = (Auth.auth().currentUser?.uid)!
            print(KTBC.Barname, "hihii")
            let startv = KTBC.viewControllers![0] as! StartVC
            startv.KellnerID = (Auth.auth().currentUser?.uid)!
            startv.Barname = barname
           
            let KABCV = KTBC.viewControllers![1] as! DetailKatVC
            KABCV.KellnerID = (Auth.auth().currentUser?.uid)!
            KABCV.Barname = barname
//
            let NVC = KTBC.viewControllers![2] as! NVC
            let EVC = NVC.viewControllers.first as! EinstellungenVC
            EVC.KellnerID = (Auth.auth().currentUser?.uid)!
            EVC.Barname = barname
            
//            let PVVC = KTBC.viewControllers![3] as! ProdukteVC
//            PVVC.KellnerID = (Auth.auth().currentUser?.uid)!
//            PVVC.Barname = barname
        }
    }
    
    func alert(title: String, message: String, actiontitle: String) {
        let alertNichtRegistriert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertNichtRegistriert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alertNichtRegistriert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == self.view {
            PasswortTextfield.resignFirstResponder()
            KellnerIdTextfield.resignFirstResponder()
        } else {
            animateOutPW()
            pwTextfield.resignFirstResponder()
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
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue){
        
    }

}

