//
//  KellnerCell2.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

class KellnerCell2: UITableViewCell, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate3 {
    
    var Bestellungen = [KellnerTVSection]()
    var Cell1Section = Int()
    var bestellungID = String()
    
    var Cell2Section = Int()
    var Cell2Row = Int()
    

    
    
    @IBOutlet weak var KellnerCelle2TV: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = Bestellungen[Cell1Section].items[Cell2Section]
        return items[Cell2Row].count
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var expanded2 = Bestellungen[Cell1Section].expanded2[Cell2Section]
        if expanded2[indexPath.section] != false {
            var extra = Bestellungen[Cell1Section].extras[Cell2Section]
            var newextra = extra[Cell2Row]
            return (CGFloat(118 + newextra[indexPath.row].count*44))
        }
        else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView3()
        var Unterkategorien = Bestellungen[Cell1Section].Unterkategorie[Cell2Section]
        
        header.customInit(tableView: tableView, title: Unterkategorien[Cell2Row], section: section, delegate: self as ExpandableHeaderViewDelegate3)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell3", owner: self, options: nil)?.first as! KellnerCell3
        
        var Items = Bestellungen[Cell1Section].items[Cell2Section]
        var Preise = Bestellungen[Cell1Section].preis[Cell2Section]
        var Mengen = Bestellungen[Cell1Section].menge[Cell2Section]
        var Kommentare = Bestellungen[Cell1Section].kommentar[Cell2Section]
        var newItems = Items[Cell2Row]
        var newPreise = Preise[Cell2Row]
        var newMengen = Mengen[Cell2Row]
        var newKommentare = Kommentare[Cell2Row]
        var Extras = Bestellungen[Cell1Section].extras[Cell2Section]
        var newExtras = Extras[Cell2Row]
        var newnewExtras = newExtras[indexPath.row]
        var ExtrasPreise = Bestellungen[Cell1Section].extrasPreis[Cell2Section]
        var newExtrasPreise = ExtrasPreise[Cell2Row]
        print(newExtras, newExtrasPreise, indexPath.row)
        var newnewExtrasPreise = newExtrasPreise[indexPath.row]
        
        cell.itemName.text = newItems[indexPath.row]
        cell.extras = newnewExtras
        cell.extrasPreise = newnewExtrasPreise
        
        let preisFormat = String(format: "%.2f", arguments: [newPreise[indexPath.row]])
        cell.itemPreis.text = "\(preisFormat) €"
        cell.itemMenge.text = String(newMengen[indexPath.row])
        cell.kommentarTextView.text = newKommentare[indexPath.row]
        return cell
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView3, section: Int) {
        print("togoglelelle")
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        KellnerCelle2TV.delegate = self
        KellnerCelle2TV.dataSource = self
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
