//
//  ExpandTVSection2.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import Foundation

struct ExpandTVSection2 {
    
    var Kategorie: String
    var Unterkategorie: [String]
    var items: [[String]]
    var preis: [[Double]]
    var liter: [[String]]
    var beschreibung: [[String]]
    var verfuegbarkeit: [[Bool]]
    var expanded2: [Bool]
    var expanded: Bool
    
    init(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], beschreibung: [[String]], verfuegbarkeit: [[Bool]], expanded2: [Bool], expanded: Bool) {
        self.Kategorie = Kategorie
        self.Unterkategorie = Unterkategorie
        self.items = items
        self.preis = preis
        self.liter = liter
        self.beschreibung = beschreibung
        self.verfuegbarkeit = verfuegbarkeit
        self.expanded2 = expanded2
        self.expanded = expanded
    }
    
}
