//
//  KellnerTBC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class KellnerTBC: UITabBarController {

    var Barname = String()
    var KellnerID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Barname, "barnamee")
//        let startvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startvc") as! StartVC
//        startvc.Barname = Barname
//        startvc.KellnerID = KellnerID
//
//        let allebe = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allebestellungen") as! KellnerAlleBestellungenVC
//               allebe.Barname = Barname
//               allebe.KellnerID = KellnerID
//
//        let evc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EVC") as! EinstellungenVC
//               evc.Barname = Barname
//               evc.KellnerID = KellnerID
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
