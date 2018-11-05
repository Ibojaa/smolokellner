//
//  KellnerExtrasCell.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class KellnerExtrasCell: UITableViewCell {
    @IBOutlet weak var extrasNameLbl: UILabel!
    @IBOutlet weak var extrasPreisLbl: UILabel!
    
    override func awakeFromNib() {
//        extrasNameLbl.textColor = UIColor.white
//        extrasPreisLbl.textColor = UIColor.white
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
