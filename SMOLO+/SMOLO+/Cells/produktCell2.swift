//
//  produktCell2.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

protocol produktCellDelegate2 {
    func verfuegbarBtnTapped(sender: produktCell2)
}

class produktCell2: UITableViewCell {
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var verfuegbarBtn: UIButton!
    
    var section2 = Int()
    var row2 = Int()
    var delegate: produktCellDelegate2?
    
    @IBAction func verfuegbarBtnTapped(_ sender: Any) {
        delegate?.verfuegbarBtnTapped(sender: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        verfuegbarBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit

        verfuegbarBtn.setImage(UIImage(named: "checkbox-i"), for: .normal)
        verfuegbarBtn.setImage(UIImage(named: "checkbox"), for: .selected)
        itemNameLbl.textColor = UIColor.white
        itemNameLbl.font = UIFont(name: "Verdana", size: 15.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
