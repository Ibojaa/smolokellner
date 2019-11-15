//
//  NVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 19.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class NVC: UINavigationController {

    var Barname = String()
    var KellnerID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Barname,"nvc")

//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.barTintColor = UIColor.green
//        self.navigationController?.navigationBar.tintColor = UIColor.red
//        self.navigationItem.titleView?.tintColor = UIColor.white
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
