//
//  AbrechnenVC.swift
//  SMOLO+
//
//  Created by Alper Maraz on 15.11.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit

class AbrechnenVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var BestellungBezahlen = [BestellungFertig]()
    
    @IBOutlet weak var AbrechnenTV: UITableView!
    func reload(){
        print("hiiiiiiiiiiii")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(BestellungBezahlen, "hallllo")
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BestellungFertigCell", owner: self, options: nil)?.first as! BestellungFertigCell
        cell.itemLBl.text = "halllo"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        // Do any additional setup after loading the view.
    }
    
     @objc func refresh() {
        print("refreshtv")
        self.AbrechnenTV.reloadData() // a refresh the tableView.

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
