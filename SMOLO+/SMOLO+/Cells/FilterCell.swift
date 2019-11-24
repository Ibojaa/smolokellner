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
                         DropDownKatsCell.updateValue(true, forKey: filterLbl.text!)
                         filterBtn.isSelected = true
                         print(DropDownKatsCell, "DDKCell1")
                         delegate?.passKatsCell(sender: self)
                     }
                     else {
                         DropDownKatsCell.updateValue(false, forKey: filterLbl.text!)
                         filterBtn.isSelected = false
                         delegate?.passKatsCell(sender: self)
                         print(DropDownKatsCell, "DDKCell2")

                     }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit    
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
