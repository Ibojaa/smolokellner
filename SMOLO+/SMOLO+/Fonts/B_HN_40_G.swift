//
//  Button_Green.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class B_HN_40_G: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 40)!
        self.tintColor = UIColor.white
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.backgroundColor = UIColor(red: 70/255, green: 188/255, blue: 0, alpha: 0.58)
    }
}
