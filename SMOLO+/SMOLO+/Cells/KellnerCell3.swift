//
//  KellnerCell3.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class KellnerCell3: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var extras = [String]()
    var extrasPreise = [Double]()
    
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPreis: UILabel!
    
    @IBOutlet weak var itemMenge: UILabel!
    
    @IBOutlet weak var kommentarTextView: UITextView!
    
    @IBOutlet weak var extrasTV: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerExtrasCell", owner: self, options: nil)?.first as! KellnerExtrasCell
        cell.extrasNameLbl.text = "+ \(extras[indexPath.row])"
        let preisFormat = String(format: "%.2f", arguments: [extrasPreise[indexPath.row]])
        cell.extrasPreisLbl.text = "+ \(preisFormat) €"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        extrasTV.delegate = self
        extrasTV.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kommentarTextView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
