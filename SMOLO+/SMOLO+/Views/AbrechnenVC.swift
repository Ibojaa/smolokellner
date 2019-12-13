//
//  AbrechnenVC.swift
//  SMOLO+
//
//  Created by Alper Maraz on 15.11.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit

protocol AbrechnenDelegate{
    func bezahlt()
}

class AbrechnenVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    func pass(bezahlt: [BestellungFertig]) {
        BestellungBezahlen = bezahlt
        print(BestellungBezahlen, "joooo")
    }
        
    var BestellungBezahlen = [BestellungFertig]()
    var delegate: AbrechnenDelegate?
    
    @IBOutlet weak var AbrechnenTV: UITableView!
    
    @IBAction func bezahlenBtn(_ sender: Any) {
        delegate?.bezahlt()
        print(1)
    }
    
    func reload(){
        print(BestellungBezahlen, "hallllo")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  BestellungBezahlen.count != 0{
        return BestellungBezahlen[0].items.count
        } else {
           return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BestellungFertigCell", owner: self, options: nil)?.first as! BestellungFertigCell
        cell.itemLBl.text = BestellungBezahlen[indexPath.section].items[indexPath.row]
        cell.mengeLbl.text = "\(BestellungBezahlen[indexPath.section].menge[indexPath.row])"
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
