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
    var fertigview: FertiggestelltVC?
    
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
        if let thridview = destination as? FertiggestelltVC{
            fertigview = thridview
            fertigview?.Barname = Barname
            fertigview?.KellnerID = KellnerID
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//     
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
