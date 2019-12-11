//
//  Ampelmodel.swift
//  SMOLO+
//
//  Created by Alper Maraz on 05.12.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import Foundation
class Ampelmodel: NSObject {
    
    var rot: Double?
    var gelb: Double?
    var rot2: Double?
    var gelb2: Double?

    init(dictionary: [String: Any]) {
        self.rot = dictionary["rot"] as? Double ?? 6000.0
        self.gelb = dictionary["gelb"] as? Double ?? 3000.0
        self.rot2 = dictionary["rot2"] as? Double ?? 6000.0
        self.gelb2 = dictionary["gelb2"] as? Double ?? 3000.0
    }
}

