//
//  ProdukteVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 30.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//


import UIKit
import Firebase

class ProdukteVC: UIViewController, UITableViewDataSource, UITableViewDelegate,ExpandableHeaderViewDelegate, produktCellDelegate {
    
    // VARS
    var cellIndexPathSection = 0
    var cellIndexPathRow = 0
    var KellnerID = String()
    var Barname = String()
    var sections = [ExpandTVSection2]()
    var Kategorien = [String]()
    var Unterkategorien = [String: [String]]()
    var Items = [String: [[String]]]()
    var Preis = [String: [[Double]]]()
    var Liter = [String: [[String]]]()
    var Beschreibung = [String: [[String]]]()
    var Verfuegbarkeit = [String: [[Bool]]]()
    var Expanded = [String: [Bool]]()
//    var delegate: bestellenCell2Delegate?
    
    var section1 = Int()
    
    
    // OUTLETS
    @IBOutlet weak var produkteTV: UITableView!
    
    
    // FUNCS
    
    func reloadUnterkategorien(sender: produktCell) {
        section1 = sender.section
        sections.removeAll()
        Kategorien.removeAll()
        Unterkategorien.removeAll()
        Items.removeAll()
        Preis.removeAll()
        Liter.removeAll()
        Beschreibung.removeAll()
        Verfuegbarkeit.removeAll()
        Expanded.removeAll()
        getKategorien()
        //        produkteTV.reloadRows(at: [IndexPath(row: 0, section: sender.section)], with: .none)
        //        produkteTV.endUpdates()
        
    }
    
    
    func pass(sender: produktCell) {
        let vKategorie = sections[cellIndexPathSection].Kategorie
        let vUnterkategorie = sections[cellIndexPathSection].Unterkategorie[sender.section2]
        var items = sections[cellIndexPathSection].items[sender.section2]
        var item = String()
        item = items[sender.row2]
        var verfuegbarkeiten = sections[cellIndexPathSection].verfuegbarkeit[sender.section2]
        var verfuegbarkeit = Bool()
        verfuegbarkeit = verfuegbarkeiten[sender.row2]
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child(self.Barname).child(vKategorie).child(vUnterkategorie).child(item).updateChildValues(["Verfuegbarkeit" : !verfuegbarkeit])
        
    }
    
    
    func getKategorien (){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        
        datref.child("Speisekarten").child("\(self.Barname)").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {
                
                if !self.Kategorien.contains(key.key) {
                    self.Kategorien.append(key.key)
                    self.getUnterKategorienItems(Kategorie: key.key)
                }
            }
        }, withCancel: nil)
    }
    
    func getUnterKategorienItems(Kategorie: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").child("\(self.Barname)").child(Kategorie).observeSingleEvent(of: .value, with: { (snapshotUnterkategorieItem) in
            
            for key in (snapshotUnterkategorieItem.children.allObjects as? [DataSnapshot])! {
                let snapshotItem = snapshotUnterkategorieItem.childSnapshot(forPath: key.key)
                
                if self.Unterkategorien[Kategorie] != nil {
                    self.Unterkategorien[Kategorie]?.append(key.key)
                    self.Expanded[Kategorie]?.append(false)
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            var newitems = self.Items[Kategorie]
                            var newpreis = self.Preis[Kategorie]
                            var newliter = self.Liter[Kategorie]
                            var newbeschreibung = self.Beschreibung[Kategorie]
                            var newverfuegbarkeit = self.Verfuegbarkeit[Kategorie]
                            
                            
                            if (self.Items[Kategorie]?.count)! < (self.Unterkategorien[Kategorie]?.count)! {
                                newitems?.append([item.Name!])
                                newpreis?.append([item.Preis!])
                                newliter?.append([item.Liter!])
                                newbeschreibung?.append([item.Beschreibung!])
                                newverfuegbarkeit?.append([item.Verfuegbarkeit!])
                                
                                
                                
                                self.Items[Kategorie] = newitems
                                self.Preis[Kategorie] = newpreis
                                self.Liter[Kategorie] = newliter
                                self.Beschreibung[Kategorie] = newbeschreibung
                                self.Verfuegbarkeit[Kategorie] = newverfuegbarkeit
                                
                                
                                
                            }
                            else {
                                newitems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newitems
                                newpreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newpreis
                                newliter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newliter
                                newbeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newbeschreibung
                                newverfuegbarkeit![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Verfuegbarkeit!)
                                self.Verfuegbarkeit[Kategorie] = newverfuegbarkeit
                                
                            }
                            
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.Unterkategorien.updateValue([key.key], forKey: Kategorie)
                    self.Expanded.updateValue([false], forKey: Kategorie)
                    
                    for items in (snapshotItem.children.allObjects as? [DataSnapshot])!{
                        if let dictionary = items.value as? [String: AnyObject]{
                            let item = SpeisekarteInformation(dictionary: dictionary)
                            
                            if self.Items[Kategorie] != nil{
                                var newItems = self.Items[Kategorie]
                                newItems![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Name!)
                                self.Items[Kategorie] = newItems
                                
                                var newPreis = self.Preis[Kategorie]
                                newPreis![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Preis!)
                                self.Preis[Kategorie] = newPreis
                                
                                var newLiter = self.Liter[Kategorie]
                                newLiter![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Liter!)
                                self.Liter[Kategorie] = newLiter
                                var newBeschreibung = self.Beschreibung[Kategorie]
                                newBeschreibung![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Beschreibung!)
                                self.Beschreibung[Kategorie] = newBeschreibung
                                var newVerfuegbarkeit = self.Verfuegbarkeit[Kategorie]
                                newVerfuegbarkeit![(self.Unterkategorien[Kategorie]?.index(of: key.key))!].append(item.Verfuegbarkeit!)
                                self.Verfuegbarkeit[Kategorie] = newVerfuegbarkeit
                                
                            } else {
                                self.Items.updateValue([[item.Name!]], forKey: Kategorie)
                                self.Preis.updateValue([[item.Preis!]], forKey: Kategorie)
                                self.Liter.updateValue([[item.Liter!]], forKey: Kategorie)
                                self.Beschreibung.updateValue([[item.Beschreibung!]], forKey: Kategorie)
                                self.Verfuegbarkeit.updateValue([[item.Verfuegbarkeit!]], forKey: Kategorie)
                                
                                
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            if self.Unterkategorien.count == self.Kategorien.count {
                
                for kategorie in self.Kategorien {
                    self.setSectionsSpeisekarte(Kategorie: kategorie, Unterkategorie: self.Unterkategorien[kategorie]!, items: self.Items[kategorie]!, preis: self.Preis[kategorie]!, liter: self.Liter[kategorie]!, beschreibung: self.Beschreibung[kategorie]!, verfuegbarkeit:  self.Verfuegbarkeit[kategorie]!, expanded2: self.Expanded[kategorie]!)
                }
                if self.produkteTV.numberOfSections < 1 {
                    self.produkteTV.reloadData()
                    print("test")
                } else {
                    self.produkteTV.beginUpdates()
                    
                    self.produkteTV.reloadRows(at: [IndexPath(row: 0, section: self.section1)], with: .none)
                    self.produkteTV.endUpdates()
                    
                }
                
            }
        }, withCancel: nil)
    }
    
    func setSectionsSpeisekarte(Kategorie: String, Unterkategorie: [String], items: [[String]], preis: [[Double]], liter: [[String]], beschreibung: [[String]], verfuegbarkeit: [[Bool]],  expanded2: [Bool]){
        self.sections.append(ExpandTVSection2(Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, beschreibung: beschreibung, verfuegbarkeit:  verfuegbarkeit, expanded2: expanded2, expanded: false))
    }
    
    
    // TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("haasfdafdfsddsf")
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var heightForRowAt: Int?
        if (sections[indexPath.section].expanded) {
            heightForRowAt = (sections[indexPath.section].Unterkategorie.count*50)
            for expandend in sections[indexPath.section].expanded2 {
                if expandend == true {
                    heightForRowAt = heightForRowAt! + sections[indexPath.section].items[indexPath.row].count*50
                }
            }
        } else {
            heightForRowAt = 0
        }
        return CGFloat(heightForRowAt!)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.contentView.layer.cornerRadius = 5
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        header.layer.cornerRadius = 5
        header.layer.backgroundColor = UIColor.clear.cgColor
        header.customInit(tableView: tableView, title: sections[section].Kategorie, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("produktCell", owner: self, options: nil)?.first as! produktCell
        
        cell.backgroundColor = UIColor.clear
        
        cell.unterkategorien = sections
        cell.items = sections[indexPath.section].items
        cell.cellIndexPathSection = indexPath.section
        cell.delegate = self
        cellIndexPathRow = indexPath.row
        cellIndexPathSection = indexPath.section
        return cell
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        
        for i in 0..<sections.count{
            if i == section {
                sections[section].expanded = !sections[section].expanded
            } else {
                sections[i].expanded = false
                
            }
        }
        
        
        produkteTV.beginUpdates()
        produkteTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
        produkteTV.endUpdates()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

        getKategorien()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
