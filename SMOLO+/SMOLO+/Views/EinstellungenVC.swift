//
//  EinstellungenVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 08.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit
import Firebase

class EinstellungenVC: UIViewController {
    
    // VARS
    var KellnerID = String()
    var Barname = String()
    
    // ACTIONS
    @IBAction func passwortaendern(_ sender: Any) {
        performSegue(withIdentifier: "passwort", sender: self)
    }
    
    @IBAction func speisekartebearbeiten(_ sender: Any) {
        performSegue(withIdentifier: "speisekarte", sender: self)
    }
    
    @IBAction func Impressum(_ sender: Any) {
        performSegue(withIdentifier: "impressum", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            do
            { try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            }
            catch let error as NSError
            { print(error.localizedDescription) }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "speisekarte" {
            
            let PVC = segue.destination as! ProdukteVC
            PVC.KellnerID = (Auth.auth().currentUser?.uid)!
            print(Barname, "barrr")
            PVC.Barname = Barname
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        self.navigationItem.title = "Einstellungen"
    }
}

