//
//  FertigeBestellung.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.12.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import Foundation
struct BestellungFertig{
    
    var BestellungID: [String: [String]]
    var Tischnummer: String
    var fromUserID: String
    var Kategorie: [String]
    var Unterkategorie: [String]
    var items: [String]
    var preis: [Double]
    var menge: [Int]
    var itemsID: [String]
    var bezahltMenge: [Int: [Int]]
    var expanded: Bool
    
    init(BestellungID: [String: [String]], tischnummer: String, fromUserID: String, Kategorie: [String], Unterkategorie: [String], items: [String], preis: [Double], menge: [Int], itemsID: [String], bezahltMenge: [Int: [Int]], expanded: Bool) {
        self.BestellungID = BestellungID
        self.Tischnummer = tischnummer
        self.fromUserID = fromUserID
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
        self.preis = preis
//        self.extras = extras
//        self.extrasPreis = extrasPreis
        self.itemsID = itemsID
        self.menge = menge
        self.bezahltMenge = bezahltMenge
        self.expanded = expanded
        
    }
    
}
