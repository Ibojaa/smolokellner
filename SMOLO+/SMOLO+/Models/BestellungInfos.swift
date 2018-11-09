//
//  BestellungInfos.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import Foundation

class BestellungInfos: NSObject {
    
    var itemName: String?
    var itemPreis: Double?
    var itemMenge: Int?
    var itemKommentar: String?
    var itemLiter: String?
    var fromUserID: String?
    var toKellnerID: String?
    var timeStamp: Double?
    var tischnummer: String?
    var Status: String?
    var bestellungItemId: String?
    
    
    init(dictionary: [String: Any]) {
        self.itemName = dictionary["Name"] as? String ?? ""
        self.itemMenge = dictionary["Menge"] as? Int ?? 0
        self.itemPreis = dictionary["Preis"] as? Double ?? 0.0
        self.itemKommentar = dictionary["Kommentar"] as? String ?? "kein Kommentar"
        self.itemLiter = dictionary["Liter"] as? String ?? "kein Liter"
        self.fromUserID = dictionary["fromUserID"] as? String ?? ""
        self.toKellnerID = dictionary["toKellnerID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Double ?? 0.0
        self.tischnummer = dictionary["tischnummer"] as? String ?? "leer"
        self.Status = dictionary["Status"] as? String ?? "Fehler"
        self.bestellungItemId = dictionary["bestellungItemId"] as? String ?? "NoID"
    }
    
}
