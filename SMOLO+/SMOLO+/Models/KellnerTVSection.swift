//
//  KellnerTVSection.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//


import Foundation
struct KellnerTVSection {
    
    var BestellungID: String
    var Tischnummer: String
    var fromUserID: String
    var TimeStamp: Double
    var Kategorie: [String]
    var Unterkategorie: [[String]]
    var items: [[[String]]]
    var preis: [[[Double]]]
    var liter: [[[String]]]
    var extras: [[[[String]]]]
    var extrasPreis: [[[[Double]]]]
    var kommentar: [[[String]]]
    var menge: [[[Int]]]
    var expanded2: [[Bool]]
    var expanded: Bool
    
    init(BestellungID: String, tischnummer: String, fromUserID: String, timeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool) {
        self.BestellungID = BestellungID
        self.Tischnummer = tischnummer
        self.fromUserID = fromUserID
        self.TimeStamp = timeStamp
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
        self.preis = preis
        self.liter = liter
        self.extras = extras
        self.extrasPreis = extrasPreis
        self.kommentar = kommentar
        self.menge = menge
        self.expanded2 = expanded2
        self.expanded = expanded
        
    }
    
}
