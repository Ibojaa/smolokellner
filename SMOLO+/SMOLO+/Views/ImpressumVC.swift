//
//  ImpressumVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 17.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class ImpressumVC: UIViewController {

    @IBAction func fertigTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        self.navigationItem.title = "Impressum"

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
