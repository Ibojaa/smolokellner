//
//  Label_weiß1.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class L_HN_36_W: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = NSTextAlignment.center
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        self.textColor = UIColor.white
    }
}
