//
//  FilterCell.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 20.11.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func passKatsCell(sender: FilterCell)
}

class FilterCell: UITableViewCell {

    // VARS and Outlets
    var DropDownKatsCell = [String: Bool]()
    var FilterRow = Int()
    var delegate: FilterCellDelegate?
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBAction func CheckFilterTapped(_ sender: Any) {
        print(filterLbl.text!, DropDownKatsCell, "FilterLbL.TExt")
        if DropDownKatsCell[filterLbl.text!] == false {
            DropDownKatsCell[filterLbl.text!] = true
            filterBtn.isSelected = true
            delegate?.passKatsCell(sender: self)
            print(DropDownKatsCell, "DDKCell")
        }
        else {
            DropDownKatsCell[filterLbl.text!] = false
            filterBtn.isSelected = false
            delegate?.passKatsCell(sender: self)
            print(DropDownKatsCell, "DDKCell")

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit

        filterBtn.setImage(UIImage(named: "checkbox"), for: .normal)
        filterBtn.setImage(UIImage(named: "checkbox-i"), for: .selected)
    
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
