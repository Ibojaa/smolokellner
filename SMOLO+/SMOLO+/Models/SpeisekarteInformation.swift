//
//  SpeisekarteInfos.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//


import Foundation
class SpeisekarteInformation: NSObject {
    var Name: String?
    var Preis: Double?
    var Liter: String?
    var Beschreibung: String?
    var Verfuegbarkeit: Bool?
    
    
    init(dictionary: [String: Any]) {
        self.Name = dictionary["Name"] as? String ?? "Fehler: Name"
        self.Preis = dictionary["Preis"] as? Double ?? 0.00
        self.Liter = dictionary["Liter"] as? String ?? "0.0l"
        self.Beschreibung = dictionary["Beschreibung"] as? String ?? " "
        self.Verfuegbarkeit = dictionary["Verfuegbarkeit"] as? Bool ?? false
        
        
    }
}



