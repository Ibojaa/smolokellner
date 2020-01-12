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
        
        let expanded2 = Bestellungen[Cell1Section].expanded2[Cell2Section]
        if expanded2[indexPath.section] != false {
            let extra = Bestellungen[Cell1Section].extras[Cell2Section]
            let newextra = extra[Cell2Row]
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
        let Unterkategorien = Bestellungen[Cell1Section].Unterkategorie[Cell2Section]
//        header.contentView.backgroundColor = UIColor(red: 146.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        header.customInit(tableView: tableView, title: Unterkategorien[Cell2Row], section: section, delegate: self as ExpandableHeaderViewDelegate3)
        return header
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell3", owner: self, options: nil)?.first as! KellnerCell3
        
        let Items = Bestellungen[Cell1Section].items[Cell2Section]
        let Preise = Bestellungen[Cell1Section].preis[Cell2Section]
        let Mengen = Bestellungen[Cell1Section].menge[Cell2Section]
        let Kommentare = Bestellungen[Cell1Section].kommentar[Cell2Section]
        let newItems = Items[Cell2Row]
        let newPreise = Preise[Cell2Row]
        let newMengen = Mengen[Cell2Row]
        let newKommentare = Kommentare[Cell2Row]
        let Extras = Bestellungen[Cell1Section].extras[Cell2Section]
        let newExtras = Extras[Cell2Row]
        let newnewExtras = newExtras[indexPath.row]
        let ExtrasPreise = Bestellungen[Cell1Section].extrasPreis[Cell2Section]
        let newExtrasPreise = ExtrasPreise[Cell2Row]
        print(newExtras, newExtrasPreise, indexPath.row)
        let newnewExtrasPreise = newExtrasPreise[indexPath.row]
        
        cell.itemName.text = newItems[indexPath.row]
        cell.extras = newnewExtras
        cell.extrasPreise = newnewExtrasPreise
        
        let preisFormat = String(format: "%.2f", arguments: [newPreise[indexPath.row]])
        cell.itemPreis.text = "\(preisFormat) €"
        cell.itemMenge.text = String(newMengen[indexPath.row])
        if newKommentare[indexPath.row] == "kein Kommentar"{
            cell.kommentarTextView.text = "hi"
            cell.kommentarTextView.frame.size.height = 3.0
        }else{
        cell.kommentarTextView.text = newKommentare[indexPath.row]
        }
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
