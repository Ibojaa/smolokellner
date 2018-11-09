//
//  L_HN_16_W.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class L_HN_16_W: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = NSTextAlignment.center
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        self.textColor = UIColor.white
    }
}
