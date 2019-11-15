//
//  StartVC.swift
//  SMOLO+
//
//  Created by Alper Maraz on 14.11.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    var KellnerID = String()
    var Barname = String()
    
    @IBOutlet weak var links: UIView!
    
    @IBOutlet weak var mitte: UIView!
    
    var kellnerview: KellnerVC?
    var angenommenview: KellnerAngenommenVC?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let firstview = destination as? KellnerVC {
          kellnerview = firstview
            kellnerview?.Barname = Barname
            kellnerview?.KellnerID = KellnerID
        }

        if let secondview = destination as? KellnerAngenommenVC {
          angenommenview = secondview
            angenommenview?.Barname = Barname
            angenommenview?.KellnerID = KellnerID
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Barname,"barname2")
        let linkscont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kellnervc") as! KellnerVC
        linkscont.Barname = Barname
        linkscont.KellnerID = KellnerID
        
        let rechtscont = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kellnerangenommenvc") as! KellnerAngenommenVC
        rechtscont.Barname = Barname
        rechtscont.KellnerID = KellnerID
//            let KACV = KTBC.viewControllers![1] as! KellnerAngenommenVC
//                       KACV.KellnerID = (Auth.auth().currentUser?.uid)!
//                       KACV.Barname = barname
        // Do any additional setup after loading the view.
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
