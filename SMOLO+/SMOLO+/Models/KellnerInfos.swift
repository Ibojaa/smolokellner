//
//  KellnerInfos.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//
import Foundation
class KellnerInfos: NSObject {
    
    var Barname: String?
    
    init(dictionary: [String: Any]) {
        self.Barname = dictionary["Barname"] as? String ?? ""
    
    }
}

