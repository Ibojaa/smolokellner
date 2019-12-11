//
//  FertigeBestellung.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.12.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import Foundation
struct BestellungFertig{
    
    var BestellungID: [String]
    var Tischnummer: String
    var fromUserID: String
    var Kategorie: [String]
    var items: [String]
    var preis: [Double]
//    var extras: [[String]]
//    var extrasPreis: [[Double]]
    var menge: [Int]
    var bezahltMenge: [Int]
    var expanded: Bool
    
    init(BestellungID: [String], tischnummer: String, fromUserID: String, Kategorie: [String], items: [String], preis: [Double], menge: [Int], bezahltMenge: [Int], expanded: Bool) {
        self.BestellungID = BestellungID
        self.Tischnummer = tischnummer
        self.fromUserID = fromUserID
        self.Kategorie = Kategorie
        self.items = items
        self.preis = preis
//        self.extras = extras
//        self.extrasPreis = extrasPreis
        self.menge = menge
        self.bezahltMenge = bezahltMenge
        self.expanded = expanded
        
    }
    
}
