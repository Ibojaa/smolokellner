//
//  DetailEinstellungenVC.swift
//  SMOLO+
//
//  Created by Alper Maraz on 06.12.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit
import Firebase

class DetailEinstellungenVC: UIViewController, UITextFieldDelegate {
    
    var Barname = String()
    var roteAmpel = Int()
    var gelbeAmpel = Int()
    var roteAmpel2 = Int()
    var gelbeAmpel2 = Int()

    @IBOutlet weak var gelbtxt: UITextField!
    
    @IBOutlet weak var rottxt: UITextField!
    
    @IBOutlet weak var gelbtxt2: UITextField!
    @IBOutlet weak var rottxt2: UITextField!
    
    
    @IBOutlet weak var aktualisieren: UIButton!
    
    @IBAction func aktualisierenaction(_ sender: Any) {
        updateAmpel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aktualisieren.isEnabled = false
        aktualisieren.alpha = 0.3
        gelbtxt.delegate = self
        gelbtxt.keyboardType = .numberPad
        rottxt.delegate = self
        rottxt.keyboardType = .numberPad
        rottxt2.delegate = self
        gelbtxt2.delegate = self
        rottxt2.keyboardType = .numberPad
        gelbtxt2.keyboardType = .numberPad
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(textFieldDidEndEditing(_:)))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        loadampel()
    }
    func loadampel(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
     datref.child("BarInfo").child(Barname).child("Ampelregel").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let ampelInfos = Ampelmodel(dictionary: dictionary)
             self.roteAmpel =   Int(ampelInfos.rot!)
             self.gelbeAmpel =   Int(ampelInfos.gelb!)
            self.roteAmpel2 =   Int(ampelInfos.rot2!)
            self.gelbeAmpel2 =   Int(ampelInfos.gelb2!)
             print(self.roteAmpel, "roteAmpellan")
             print(snapshot,"Ampelshot")
                self.rottxt.text = "\(self.roteAmpel/60)"
                self.gelbtxt.text = "\(self.gelbeAmpel/60)"
                self.rottxt2.text = "\(self.roteAmpel2/60)"
                self.gelbtxt2.text = "\(self.gelbeAmpel2/60)"
            }
        }, withCancel: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == gelbtxt || textField == rottxt {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        if gelbtxt.hasText == true && rottxt.hasText == true && gelbtxt2.hasText == true && rottxt2.hasText == true {
            aktualisieren.isEnabled = true
            aktualisieren.alpha = 1.0
        }else {
            aktualisieren.isEnabled = false
            aktualisieren.alpha = 0.3
        }
    }
    
    func updateAmpel(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        if gelbtxt.text?.count != 0  {
            let gelbminuten = Double(gelbtxt.text!)
            let gelbsekunden = gelbminuten! * 60.0
            datref.child("BarInfo").child(self.Barname).child("Ampelregel").updateChildValues(["gelb": gelbsekunden])
        }
        if rottxt.text != nil && rottxt.text != "" {
            let rotmin = Double(rottxt.text!)
            let rotsekunden = rotmin! * 60.0
        datref.child("BarInfo").child(self.Barname).child("Ampelregel").updateChildValues(["rot": rotsekunden])
        }
        if rottxt2.text != nil && rottxt2.text != "" {
            let rotmin2 = Double(rottxt2.text!)
            let rotsekunden2 = rotmin2! * 60.0
        datref.child("BarInfo").child(self.Barname).child("Ampelregel").updateChildValues(["rot": rotsekunden2])
        }
        if gelbtxt2.text != nil && gelbtxt2.text != "" {
            let gelbmin2 = Double(gelbtxt2.text!)
            let gelbsekunden2 = gelbmin2! * 60.0
        datref.child("BarInfo").child(self.Barname).child("Ampelregel").updateChildValues(["rot": gelbsekunden2])
        }
       }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
