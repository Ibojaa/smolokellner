//
//  EinstellungenVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 08.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class EinstellungenVC: UIViewController {
    
    // VARS
    var KellnerID = String()
    var Barname = String()
    
    // ACTIONS
    @IBAction func passwortaendern(_ sender: Any) {
    }
    
    @IBAction func speisekartebearbeiten(_ sender: Any) {
        performSegue(withIdentifier: "speisekarte", sender: self)
    }
    
    @IBAction func Impressum(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

    }
}

