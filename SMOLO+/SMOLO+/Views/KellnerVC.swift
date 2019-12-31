//
//  KellnerVC.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 14.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit
import Firebase

class KellnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate, kellnerCellDelegate{
    // VARS
    var Barname = String()
    var KellnerID = String()
    var ItemsPreis = [Double]()
    var ItemsMenge = [Double]()
    var ExtraPreis = [Double]()
    var Bestellungen = [KellnerTVSection]()
    var bestellungIDs = [String]()
    var BestellungKategorien = [String: [String]]()
    var BestellungUnterkategorien = [String: [[String]]]()
    var BestellungExpanded2 = [String: [[Bool]]]()
    
    var BestellungItemsNamen = [String: [[[String]]]]()
    var BestellungItemsPreise = [String: [[[Double]]]]()
    var BestellungItemsMengen = [String: [[[Int]]]]()
    var BestellungItemsKommentar = [String: [[[String]]]]()
    var BestellungItemsLiter = [String: [[[String]]]]()
    var BestellungenItemsExtrasNamen = [String: [[[[String]]]]]()
    var BestellungenItemsExtrasPreise = [String: [[[[Double]]]]]()
    var BestellungItemsID = [String: [[[String]]]]()
    var Tischnummer = [String: String]()
    var Angenommen = [String: String]()
    var FromUserID = [String: String]()
    var TimeStamp = [String: Double]()
    var extrasString = [String]()
    var extrasPreis = [Double]()
    var viewBestellungID = String()
    
    var problemSection = 0
    var problemRow = 0
     var gesamtpreislabel = 0.0
    
    var roteAmpel = Double()
    var gelbeAmpel = Double()
    var gruneAmpel = 0.0
    // OUTLETS

    @IBOutlet weak var barnameLbl: UILabel!
    
    
    @IBOutlet weak var bestellungTV: UITableView!
    
    @IBOutlet var viewProblem: UIView!
    
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet var viewTischumbuchen: UIView!
    
    @IBOutlet weak var umbuchenTextfield: UITextField!
    @IBOutlet var visualeffekt: UIVisualEffectView!
    
    func loadBestellungenKeys(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                if bestellungInfos.Status == "versendet" {
                    self.bestellungIDs.append(snapshot.key)
                    self.loadBestellungen(BestellungID: snapshot.key)
                }
            }
            
        }, withCancel: nil)
        
    }
    func loadampel(){
           var datref: DatabaseReference!
           datref = Database.database().reference()
        datref.child("BarInfo").child(Barname).child("Ampelregel").observe(.value, with: { (snapshot) in
               if let dictionary = snapshot.value as? [String: AnyObject]{
                   let ampelInfos = Ampelmodel(dictionary: dictionary)
                self.roteAmpel =   Double(ampelInfos.rot!)
                self.gelbeAmpel =   Double(ampelInfos.gelb!)
                print(self.roteAmpel, "roteAmpellan")
                print(snapshot,"Ampelshot")
               }
           }, withCancel: nil)
       }
    
    func loadBestellungen(BestellungID: String){
        
        Bestellungen.removeAll()

        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").child(Barname).child(BestellungID).observeSingleEvent(of: .value) { (snapshot) in
            
            for key in (snapshot.children.allObjects as? [DataSnapshot])! {
                if key.key == "Information" {
                    if let dictionary = key.value as? [String: AnyObject]{
                        let bestellungInfos = BestellungInfos(dictionary: dictionary)
                        self.Tischnummer.updateValue(bestellungInfos.tischnummer!, forKey: BestellungID)
                        self.FromUserID.updateValue(bestellungInfos.fromUserID!, forKey: BestellungID)
                        self.TimeStamp.updateValue(bestellungInfos.timeStamp!, forKey: BestellungID) }}
                else  {
                let childsnapshotUnterkategorie = snapshot.childSnapshot(forPath: key.key)
                if self.BestellungKategorien[BestellungID] != nil {
                    self.BestellungKategorien[BestellungID]?.append(key.key)
                    
                    for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
                        let childsnapshotItem = childsnapshotUnterkategorie.childSnapshot(forPath: children.key)
                        var x = self.BestellungUnterkategorien[BestellungID]
                        var expandend2 = self.BestellungExpanded2[BestellungID]
                        if x!.count < (self.BestellungKategorien[BestellungID]?.count)!{
                            x!.append([children.key])
                            expandend2!.append([true])
                            self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                            self.BestellungExpanded2.updateValue(expandend2!, forKey: BestellungID)
                            for Item in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                if let itemDic = Item.value as? [String: AnyObject]{
                                    let iteminfodic = BestellungInfos(dictionary: itemDic)
                                    var newItems = self.BestellungItemsNamen[BestellungID]
                                    var newPreise = self.BestellungItemsPreise[BestellungID]
                                    var newMengen = self.BestellungItemsMengen[BestellungID]
                                    var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                    var newLiters = self.BestellungItemsLiter[BestellungID]
                                    var newItemsID = self.BestellungItemsID[BestellungID]
                                    if (newItems?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                        newItems?.append([[iteminfodic.itemName!]])
                                        newPreise?.append([[Double(iteminfodic.itemPreis!)]])
                                        newMengen?.append([[Int(iteminfodic.itemMenge!)]])
                                        newKommentare?.append([[iteminfodic.itemKommentar!]])
                                        newLiters?.append([[iteminfodic.itemLiter!]])
                                        newItemsID?.append([[iteminfodic.bestellungItemId!]])
                                        self.BestellungItemsNamen[BestellungID] = newItems
                                        self.BestellungItemsPreise[BestellungID] = newPreise
                                        self.BestellungItemsMengen[BestellungID] = newMengen
                                        self.BestellungItemsKommentar[BestellungID] = newKommentare
                                        self.BestellungItemsLiter[BestellungID] = newLiters
                                        self.BestellungItemsID[BestellungID] = newItemsID
                                        } else {
                                        var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewItemsID = newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                        newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                        newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                        newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                        newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                        newnewItemsID[newx.index(of: children.key)!].append(iteminfodic.bestellungItemId!)
                                        newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                        newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                        newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                        newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                        newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                        newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID

                                        self.BestellungItemsNamen[BestellungID] = newItems
                                        self.BestellungItemsPreise[BestellungID] = newPreise
                                        self.BestellungItemsMengen[BestellungID] = newMengen
                                        self.BestellungItemsKommentar[BestellungID] = newKommentare
                                        self.BestellungItemsLiter[BestellungID] = newLiters
                                        self.BestellungItemsID[BestellungID] = newItemsID
                                    }} }
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                self.extrasString.append(extraInfo.itemName!)
                                                self.extrasPreis.append(extraInfo.itemPreis!)
                                                if (newExtras?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                        newExtras?.append([[self.extrasString]])
                                                        newPreis?.append([[self.extrasPreis]])
                                                        self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                        self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                        self.extrasString.removeAll()
                                                        self.extrasPreis.removeAll()
                                                    }} else {
                                                    var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                    var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount {
                                                        let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                        newnewExtras[newx.index(of: children.key)!].append(self.extrasString)
                                                        newnewPreis[newx.index(of: children.key)!].append(self.extrasPreis)
                                                        newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                        newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                        self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                        self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                        self.extrasString.removeAll()
                                                        self.extrasPreis.removeAll()
                                                    }}}}} }}
                        } else {
                            x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                            expandend2![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(true)
                            self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                            self.BestellungExpanded2.updateValue(expandend2!, forKey: BestellungID)
                            for Item in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                if let itemDic = Item.value as? [String: AnyObject]{
                                    
                                    let iteminfodic = BestellungInfos(dictionary: itemDic)
                                    var newItems = self.BestellungItemsNamen[BestellungID]
                                    var newPreise = self.BestellungItemsPreise[BestellungID]
                                    var newMengen = self.BestellungItemsMengen[BestellungID]
                                    var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                    var newLiter = self.BestellungItemsLiter[BestellungID]
                                    var newItemsID = self.BestellungItemsID[BestellungID]
                                    var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    var newnewLiters = newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    var newnewItemsID = newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                    if newnewItem.count < newx.count {
                                        newnewItem.append([iteminfodic.itemName!])
                                        newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                        newnewMengen.append([iteminfodic.itemMenge!])
                                        newnewKommentare.append([iteminfodic.itemKommentar!])
                                        newnewLiters.append([iteminfodic.itemLiter!])
                                        newnewItemsID.append([iteminfodic.bestellungItemId!])
                                        newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                        newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                        newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                        newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                        newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                        newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID
                                        self.BestellungItemsNamen[BestellungID] = newItems
                                        self.BestellungItemsPreise[BestellungID] = newPreise
                                        self.BestellungItemsMengen[BestellungID] = newMengen
                                        self.BestellungItemsKommentar[BestellungID] = newKommentare
                                        self.BestellungItemsLiter[BestellungID] = newLiter
                                        self.BestellungItemsID[BestellungID] = newItemsID
                                    } else {
                                        newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                        newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                        newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                        newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                        newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                        newnewItemsID[newx.index(of: children.key)!].append(iteminfodic.bestellungItemId!)

                                        newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                        newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                        newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                        newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                        newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                        newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID
                                        self.BestellungItemsNamen[BestellungID] = newItems
                                        self.BestellungItemsPreise[BestellungID] = newPreise
                                        self.BestellungItemsMengen[BestellungID] = newMengen
                                        self.BestellungItemsKommentar[BestellungID] = newKommentare
                                        self.BestellungItemsLiter[BestellungID] = newLiter
                                        self.BestellungItemsID[BestellungID] = newItemsID
                                    }}}
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                if newnewExtras.count  < newx.count{
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    newnewExtras.append([self.extrasString])
                                                    newnewPreis.append([self.extrasPreis])
                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                    self.extrasPreis.removeAll()
                                                    self.extrasString.removeAll()
                                                } else {
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                        newnewExtras[newx.index(of: children.key)!].append(self.extrasString)
                                                        newnewPreis[newx.index(of: children.key)!].append(self.extrasPreis)
                                                        newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                        newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                        self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                        self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                        self.extrasPreis.removeAll()
                                                        self.extrasString.removeAll()
                                                    }}}}} }}}}} else {
                    /// self.BestellungKategorien[BestellungID] == nil
                    self.BestellungKategorien.updateValue([key.key], forKey: BestellungID)
                    for children in (childsnapshotUnterkategorie.children.allObjects as? [DataSnapshot])! {
                        let childsnapshotItem = childsnapshotUnterkategorie.childSnapshot(forPath: children.key)
                        if self.BestellungUnterkategorien[BestellungID] != nil {
                            var x = self.BestellungUnterkategorien[BestellungID]
                            var expanded2 = self.BestellungExpanded2[BestellungID]
                            x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(children.key)
                            expanded2![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!].append(true)
                            self.BestellungUnterkategorien.updateValue(x!, forKey: BestellungID)
                            self.BestellungExpanded2.updateValue(expanded2!, forKey: BestellungID)
                            for Item in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                
                                if let itemDic = Item.value as? [String: AnyObject]{
                                    let iteminfodic = BestellungInfos(dictionary: itemDic)
                                    if self.BestellungItemsNamen[BestellungID] != nil {
                                        var newItems = self.BestellungItemsNamen[BestellungID]
                                        var newPreise = self.BestellungItemsPreise[BestellungID]
                                        var newMengen = self.BestellungItemsMengen[BestellungID]
                                        var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                        var newLiters = self.BestellungItemsLiter[BestellungID]
                                        var newItemsID = self.BestellungItemsID[BestellungID]
                                        var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewItemsID = newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        if newnewItems.count < newx.count {
                                            newnewItems.append([iteminfodic.itemName!])
                                            newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                            newnewMengen.append([iteminfodic.itemMenge!])
                                            newnewKommentare.append([iteminfodic.itemKommentar!])
                                            newnewLiters.append([iteminfodic.itemLiter!])
                                            newnewItemsID.append([iteminfodic.bestellungItemId!])
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID
                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiters
                                            self.BestellungItemsID[BestellungID] = newItemsID
                                            } else {
                                            newnewItems[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                            newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                            newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                            newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                            newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                            newnewItemsID[newx.index(of: children.key)!].append(iteminfodic.bestellungItemId!)
                                            newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                            newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                            newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                            newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                            newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                            newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID

                                            self.BestellungItemsNamen[BestellungID] = newItems
                                            self.BestellungItemsPreise[BestellungID] = newPreise
                                            self.BestellungItemsMengen[BestellungID] = newMengen
                                            self.BestellungItemsKommentar[BestellungID] = newKommentare
                                            self.BestellungItemsLiter[BestellungID] = newLiters
                                            self.BestellungItemsID[BestellungID] = newItemsID                                           }}}}
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                self.extrasString.append(extraInfo.itemName!)
                                                self.extrasPreis.append(extraInfo.itemPreis!)
                                                if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount {
                                                    let a = self.BestellungUnterkategorien[BestellungID]!
                                                    let b = a[(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                    let c = b.index(of: children.key)
                                                    if newnewExtras.count < c!+1 {
                                                        newnewExtras.append([self.extrasString])
                                                        newnewPreis.append([self.extrasPreis])
                                                    } else {
                                                        newnewExtras[c!].append(self.extrasString)
                                                        newnewPreis[c!].append(self.extrasPreis) }
                                                    newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                    newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                    self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                    self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                    self.extrasString.removeAll()
                                                    self.extrasPreis.removeAll()
                                                }}}}}}
                        } else {
                            self.BestellungUnterkategorien.updateValue([[children.key]], forKey: BestellungID)
                            self.BestellungExpanded2.updateValue([[true]], forKey: BestellungID)
                            for Item in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                if let itemDic = Item.value as? [String: AnyObject]{
                                    let iteminfodic = BestellungInfos(dictionary: itemDic)
                                    if self.BestellungItemsNamen[BestellungID] != nil {
                                        var newItems = self.BestellungItemsNamen[BestellungID]
                                        var newPreise = self.BestellungItemsPreise[BestellungID]
                                        var newMengen = self.BestellungItemsMengen[BestellungID]
                                        var newKommentare = self.BestellungItemsKommentar[BestellungID]
                                        var newLiters = self.BestellungItemsLiter[BestellungID]
                                        var newItemsID = self.BestellungItemsID[BestellungID]
                                        var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        var newnewItemsID = newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                        newnewItems[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemName!)
                                        newnewPreise[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(Double(iteminfodic.itemPreis!))
                                        newnewMengen[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemMenge!)
                                        newnewKommentare[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemKommentar!)
                                        newnewLiters[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemLiter!)
                                        newnewItemsID[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.bestellungItemId!)
                                        newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                        newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                        newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                        newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                        newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                        newItemsID![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItemsID
                                        self.BestellungItemsNamen[BestellungID] = newItems
                                        self.BestellungItemsPreise[BestellungID] = newPreise
                                        self.BestellungItemsMengen[BestellungID] = newMengen
                                        self.BestellungItemsKommentar[BestellungID] = newKommentare
                                        self.BestellungItemsLiter[BestellungID] = newLiters
                                        self.BestellungItemsID[BestellungID] = newItemsID
                                        } else {
                                        self.BestellungItemsNamen.updateValue([[[iteminfodic.itemName!]]], forKey: BestellungID)
                                        self.BestellungItemsPreise.updateValue([[[Double(iteminfodic.itemPreis!)]]], forKey: BestellungID)
                                        self.BestellungItemsMengen.updateValue([[[iteminfodic.itemMenge!]]], forKey: BestellungID)
                                        self.BestellungItemsKommentar.updateValue([[[iteminfodic.itemKommentar!]]], forKey: BestellungID)
                                        self.BestellungItemsLiter.updateValue([[[iteminfodic.itemLiter!]]], forKey: BestellungID)
                                        self.BestellungItemsID.updateValue([[[iteminfodic.bestellungItemId!]]], forKey: BestellungID)

                                    }}
                            }
                            for Itemssnap in (childsnapshotItem.children.allObjects as? [DataSnapshot])! {
                                let childsnapshotExtras = childsnapshotItem.childSnapshot(forPath: Itemssnap.key)
                                for extras in (childsnapshotExtras.children.allObjects as? [DataSnapshot])! {
                                    let extrasSnap = childsnapshotExtras.childSnapshot(forPath: extras.key)
                                    if extrasSnap.key == "Extras" {
                                        let childsnapshotExtra = childsnapshotExtras.childSnapshot(forPath: extrasSnap.key)
                                        for extra in (childsnapshotExtra.children.allObjects as? [DataSnapshot])! {
                                            if let dictionary = extra.value as? [String: AnyObject]{
                                                let extraInfo = BestellungInfos(dictionary: dictionary)
                                                if self.BestellungenItemsExtrasNamen[BestellungID] != nil {
                                                    var newExtras = self.BestellungenItemsExtrasNamen[BestellungID]
                                                    var newnewExtras = newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    var newPreis = self.BestellungenItemsExtrasPreise[BestellungID]
                                                    var newnewPreis = newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{                                                            newnewExtras[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(self.extrasString)
                                                        newExtras![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewExtras
                                                        self.BestellungenItemsExtrasNamen[BestellungID] = newExtras
                                                        newnewPreis[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].insert(self.extrasPreis, at: 0)
                                                        newPreis![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreis
                                                        self.BestellungenItemsExtrasPreise[BestellungID] = newPreis
                                                        self.extrasString.removeAll()
                                                        self.extrasPreis.removeAll()
                                                    }} else {
                                                    self.extrasString.append(extraInfo.itemName!)
                                                    self.extrasPreis.append(extraInfo.itemPreis!)
                                                    if self.extrasString.count == extrasSnap.childrenCount && self.extrasPreis.count == extrasSnap.childrenCount{
                                                        self.BestellungenItemsExtrasNamen.updateValue([[[self.extrasString]]], forKey: BestellungID)
                                                        self.BestellungenItemsExtrasPreise.updateValue([[[self.extrasPreis]]], forKey: BestellungID)
                                                        self.extrasPreis.removeAll()
                                                        self.extrasString.removeAll()
                                                    }}}}}}}
                        } }  }} }
            print(self.bestellungIDs.count, self.BestellungKategorien.count, "countprint" )
            if self.bestellungIDs.count == self.BestellungKategorien.count {
                for i in 0..<self.bestellungIDs.count {
                    self.setSectionsKellnerBestellung(BestellungID: self.bestellungIDs[i], tischnummer: self.Tischnummer[self.bestellungIDs[i]]!, fromUserID: self.FromUserID[self.bestellungIDs[i]]!, TimeStamp: self.TimeStamp[self.bestellungIDs[i]]!, Kategorie: self.BestellungKategorien[self.bestellungIDs[i]]!, Unterkategorie: self.BestellungUnterkategorien[self.bestellungIDs[i]]!, items: self.BestellungItemsNamen[self.bestellungIDs[i]]!, preis: self.BestellungItemsPreise[self.bestellungIDs[i]]!, liter: self.BestellungItemsLiter[self.bestellungIDs[i]]!, extras: self.BestellungenItemsExtrasNamen[self.bestellungIDs[i]]!, extrasPreis: self.BestellungenItemsExtrasPreise[self.bestellungIDs[i]]!, kommentar: self.BestellungItemsKommentar[self.bestellungIDs[i]]!, menge: self.BestellungItemsMengen[self.bestellungIDs[i]]!, itemsID: self.BestellungItemsID[self.bestellungIDs[i]]!, expanded2: self.BestellungExpanded2[self.bestellungIDs[i]]!, expanded: false)
                    print(self.Bestellungen.count, self.bestellungIDs.count, "bestellungencount2")
                    if self.Bestellungen.count == self.bestellungIDs.count{
                        self.bestellungTV.reloadData()
                    }}}}}
    
    
    func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, fromUserID: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], itemsID: [[[String]]],expanded2: [[Bool]], expanded: Bool){
        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, extras: extras, extrasPreis: extrasPreis, kommentar: kommentar, menge: menge, itemsID: itemsID, expanded2: expanded2, expanded: expanded))
        }
    
    func removeBestellung(KellnerID: String, BestellungID: String){
        print("removebestellung")
        var datref: DatabaseReference!
        datref = Database.database().reference()
//    datref.child("Bestellungen").child(Barname).child(BestellungID).child("Information").observe(.childAdded, with: { (snapshot) in
//
//        if let dicti = snapshot.value as? [String:Any]{
//
//            let vorgangsstatus = dicti["Status"] as? String
//            print(vorgangsstatus!, "STATUS!!!!!!")
//            if vorgangsstatus == "versendet" {
                datref.child("Bestellungen").child(self.Barname).child(BestellungID).child("Information").updateChildValues(["Status": "angenommen"])
                datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["Status": "angenommen"])
           // }}})
        
    }
    
    //     SWIPE ACTIONS
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Problem") { (action, view, completion) in
            completion(true)
            self.problemSection = indexPath.section
            self.problemRow = indexPath.row
            self.viewBestellungID = self.Bestellungen[indexPath.section].BestellungID
            self.animateInProblem()
        }
        return action
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let annehmen = tischumbuchen(at: indexPath)
        annehmen.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [annehmen])
    }
    
    func tischumbuchen(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "umbuchen") { (action, view, completion) in
            completion(true)
            self.animateInTisch()
        }
        return action
    }
    

    @IBAction func viewProblemAbbrechen(_ sender: Any) {
        animateOutProblem()

    }
    
    @IBAction func viewProblemAbschicken(_ sender: Any) {
        
        if problemTextView.text != "" {
            let problemTisch = self.Bestellungen[problemSection].Tischnummer
            let problemTimeStamp = self.Bestellungen[problemSection].TimeStamp
            let fromUserID = self.Bestellungen[problemSection].fromUserID
            var datref: DatabaseReference!
            datref = Database.database().reference()
            let childdatref  = datref.child("ProblemMeldungenKellner").child(KellnerID)
            let childchilddatref = childdatref.childByAutoId()
            childchilddatref.child("Information").updateChildValues(["Problemtext" : problemTextView.text!, "BestellungID": self.Bestellungen[problemSection].BestellungID, "tischnummer": problemTisch, "fromUserID": fromUserID, "TimeStamp": problemTimeStamp])
            
            
            let Bestellung = Bestellungen[problemSection]
            for i in 0..<Bestellung.Kategorie.count{
                let Unterkategorien = Bestellung.Unterkategorie[i]
                
                for Unterkategorie in Unterkategorien {
                    let UnterkategorieSection = Unterkategorien.index(of: Unterkategorie)
                    var items = Bestellung.items[i]
                    var item = items[UnterkategorieSection!]
                    var mengen = Bestellung.menge[i]
                    var menge = mengen[UnterkategorieSection!]
                    var preise = Bestellung.preis[i]
                    var preis = preise[UnterkategorieSection!]
                    var kommentare = Bestellung.kommentar[i]
                    var kommentar = kommentare[UnterkategorieSection!]
                    for x in 0 ..< items.count {
                        
                        let bestellungName = ["Name": item[x]]
                        let bestellungMenge = ["Menge": menge[x]]
                        let bestellungPreis = ["Preis": preis[x]]
                        let bestellungKommentar = ["Kommentar": kommentar[x]]
                        
                        childchilddatref.child("Bestellung").child(Bestellung.Kategorie[i]).child(Unterkategorie).child(item[x]).updateChildValues(bestellungName)
                        childchilddatref.child("Bestellung").child(Bestellung.Kategorie[i]).child(Unterkategorie).child(item[x]).updateChildValues(bestellungMenge)
                        childchilddatref.child("Bestellung").child(Bestellung.Kategorie[i]).child(Unterkategorie).child(item[x]).updateChildValues(bestellungPreis)
                        childchilddatref.child("Bestellung").child(Bestellung.Kategorie[i]).child(Unterkategorie).child(item[x]).updateChildValues(bestellungKommentar)
                        
                    }
                }
            }
            
            animateOutProblem()
        }
        else {
            let alertKeineBestellung = UIAlertController(title: "problem beschreiben", message: "Gib eine neue Tischnummer an", preferredStyle: .alert)
            alertKeineBestellung.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertKeineBestellung, animated: true, completion: nil)        }
        
        animateOutProblem()
    }
    

    
    @IBAction func viewTischumbuchenAbbrechen(_ sender: Any) {
        animateOutTisch()

    }
    
    @IBAction func viewTischumbuchen(_ sender: Any) {
        if umbuchenTextfield.text != "" {
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("Bestellungen").child(Barname).child(viewBestellungID).child("Information").updateChildValues(["tischnummer" : umbuchenTextfield.text!])
            animateOutTisch()
            
            //            reload()
        }
        else {
            let alertKeineBestellung = UIAlertController(title: "Tisch umbuchen", message: "Gib eine neue Tischnummer an", preferredStyle: .alert)
            alertKeineBestellung.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertKeineBestellung, animated: true, completion: nil)        }
    }
    
    func animateInProblem(){
        
        self.view.addSubview(visualeffekt)
        visualeffekt.center = self.view.center
        visualeffekt.bounds.size = self.view.bounds.size
        self.view.addSubview(viewProblem)
        viewProblem.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: viewProblem, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 240),
            NSLayoutConstraint(item: viewProblem, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 218),
            NSLayoutConstraint(item: viewProblem, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: viewProblem, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: -100),
            ])
        
        
        //        viewProblem.center = self.view.center
        viewProblem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewProblem.alpha = 0
        problemTextView.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.viewProblem.alpha = 1
            self.viewProblem.transform = CGAffineTransform.identity
        }
    }
    
    @objc func animateOutProblem(){
        UIView.animate(withDuration: 0.1, animations: {
            self.problemTextView.resignFirstResponder()
            
            self.viewProblem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewProblem.alpha = 0
        }) { (sucess:Bool) in
            self.viewProblem.removeFromSuperview()
            self.visualeffekt.removeFromSuperview()
        }
    }
    
    func animateInTisch(){
        self.view.addSubview(visualeffekt)
        visualeffekt.center = self.view.center
        visualeffekt.bounds.size = self.view.bounds.size
        self.view.addSubview(viewTischumbuchen)
        viewTischumbuchen.center = self.view.center
        viewTischumbuchen.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewTischumbuchen.alpha = 0
        umbuchenTextfield.keyboardType = UIKeyboardType.numberPad
        umbuchenTextfield.becomeFirstResponder()
        
        
        UIView.animate(withDuration: 0.2) {
            self.viewTischumbuchen.alpha = 1
            self.viewTischumbuchen.transform = CGAffineTransform.identity
        }
    }
    
    @objc func animateOutTisch(){
        UIView.animate(withDuration: 0.1, animations: {
            self.problemTextView.resignFirstResponder()
            
            self.viewTischumbuchen.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewTischumbuchen.alpha = 0
            
        }) { (sucess:Bool) in
            self.viewTischumbuchen.removeFromSuperview()
            self.visualeffekt.removeFromSuperview()
        }
    }
    
    func annehmen(sender: KellnerCell) {
        self.removeBestellung(KellnerID: self.KellnerID, BestellungID:
            self.Bestellungen[sender.Cell1Section].BestellungID)
        self.reload()
    }
    
    
    
    // TABLE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Bestellungen.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightForHeaderInSection: Int?
        
        heightForHeaderInSection = 36
        return CGFloat(heightForHeaderInSection!)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if (Bestellungen[indexPath.section].expanded) {
            let kategorieCount = Bestellungen[indexPath.section].Kategorie.count
            var UnterkategorieCount = 0
            var itemsCount = 0
            var extraCount = 0
            for items in  Bestellungen[indexPath.section].items {
                for item in items {
                    itemsCount = itemsCount + item.count
                }
            }
            
            for extras in Bestellungen[indexPath.section].extras {
                for extra in extras {
                    for newextras in extra {
                        extraCount = extraCount + newextras.count
                    }
                }
            }
            for unterkategorie in Bestellungen[indexPath.section].Unterkategorie {
                UnterkategorieCount = UnterkategorieCount + unterkategorie.count
            }
            return CGFloat(kategorieCount*40 + UnterkategorieCount*50 + itemsCount*120 + extraCount*50)
        }
        else {
            return 0
        }
        
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
        header.contentView.layer.cornerRadius = 0
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        header.layer.cornerRadius = 0
        header.layer.backgroundColor = UIColor.clear.cgColor
       // header.contentView.backgroundColor = UIColor(red: 185.0/255.0, green: 170.0/255.0, blue: 140.0/255.0, alpha: 1.0)

        header.customInit(tableView: tableView, title: Bestellungen[section].Tischnummer, section: section, delegate: self as ExpandableHeaderViewDelegate)
      
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")

        let reftime = Date(timeInterval: self.Bestellungen[section].TimeStamp, since: DayOne!)
        let aktuell = Date()
        let intervale = aktuell.timeIntervalSince(reftime)
        print(intervale, gelbeAmpel, roteAmpel, "Timeinterval")

        if intervale < gelbeAmpel {
            header.contentView.backgroundColor = UIColor(red: 70/255, green: 188/255, blue: 0, alpha: 0.58)
        }
        if intervale > gelbeAmpel && intervale < roteAmpel {
                   header.contentView.backgroundColor = UIColor(red: 146.0/255.0, green: 144.0/255.0, blue: 0.0/255.0, alpha: 1.0)
               }
        if intervale > roteAmpel {
            header.contentView.backgroundColor = UIColor(red: 224/255, green: 41/255, blue: 0/255, alpha: 0.63)
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        
        cell.Bestellungen = Bestellungen
        cell.Cell1Section = indexPath.section
        cell.annehmen.setTitle("Annehmen", for: .normal)
        cell.bestellungID = Bestellungen[indexPath.section].BestellungID
        cell.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")
        let timeStampDate = NSDate(timeInterval: self.Bestellungen[indexPath.section].TimeStamp, since: DayOne!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
    
        cell.timeLbl.text = "\(dateFormatter.string(from: timeStampDate as Date)) Uhr"
        
        
        if Bestellungen[indexPath.section].expanded == false {
            cell.timeLbl.isHidden = true
            cell.gesamtPreisLbl.isHidden = true
            cell.annehmen.isHidden = true
            
        } else {
            cell.gesamtPreisLbl.isHidden = false
            cell.timeLbl.isHidden = false
            cell.annehmen.isHidden = false

        }
        ExtraPreis.removeAll()
        ItemsPreis.removeAll()
        ItemsMenge.removeAll()
        gesamtpreisBerechnen(section: indexPath.section, row: indexPath.row)

        cell.gesamtPreisLbl.text = "\(String(format: "%.2f", gesamtpreislabel)) €"
        return cell
        
    }
    
    
    func gesamtpreisBerechnen(section: Int, row: Int) {
        gesamtpreislabel = 0.0
        print(Bestellungen[section].preis, "Bestellungen[indexPath.section].preis")
        print(Bestellungen[section].menge, "Bestellungen[indexPath.section].menge")
        print(Bestellungen[section].extrasPreis, "Bestellungen[section].extrasPreis")
        ExtraPreis.removeAll()
        ItemsPreis.removeAll()
        ItemsMenge.removeAll()
        for extrasPreise in Bestellungen[section].extrasPreis {
            for extrasPreis in extrasPreise {
                for extraPreis in extrasPreis {
                    for preis in extraPreis {
                        ExtraPreis.append(preis)
                    }
                }
            }
        }
        
        for itemsPreise in  Bestellungen[section].preis {
            for itemPreise in itemsPreise {
                for preis in itemPreise {
                    print(preis, 5)
                    ItemsPreis.append(preis)
                }
            }
        }
        
        for itemsMengen in  Bestellungen[section].menge {
            for itemsMenge in itemsMengen {
                for menge in itemsMenge {
                    print(menge, 6)
                    ItemsMenge.append(Double(menge))
                }
            }
        }
        teilPreis(itemPreis: ItemsPreis, extrasPreis: ExtraPreis, menge: ItemsMenge)
    
    }
    func teilPreis(itemPreis: [Double], extrasPreis: [Double], menge: [Double]) {
       
        for i in 0..<itemPreis.count{
            gesamtpreislabel += (itemPreis[i]+extrasPreis[i])*menge[i]
        print(menge, itemPreis, extrasPreis, "variablen")
            print(gesamtpreislabel, "preiiiis")
            
            
        }
    }
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        bestellungTV.beginUpdates()
        
        for i in 0..<Bestellungen.count{
            if i == section {
                Bestellungen[section].expanded = !Bestellungen[section].expanded
                
            } else {
                Bestellungen[i].expanded = false
                
            }
        }
        
        
        bestellungTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
        bestellungTV.endUpdates()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != viewProblem && touch?.view != viewTischumbuchen {
            animateOutTisch()
            animateOutProblem()
        }
    }
    
    
    
    // Others
    
    func reload(){
        Bestellungen.removeAll()
        bestellungIDs.removeAll()
        BestellungKategorien.removeAll()
        BestellungUnterkategorien.removeAll()
        BestellungExpanded2.removeAll()
        BestellungItemsNamen.removeAll()
        BestellungItemsPreise.removeAll()
        BestellungItemsMengen.removeAll()
        BestellungenItemsExtrasNamen.removeAll()
        BestellungenItemsExtrasPreise.removeAll()
        BestellungItemsID.removeAll()
        Tischnummer.removeAll()
        Angenommen.removeAll()
        FromUserID.removeAll()
        TimeStamp.removeAll()
        loadBestellungenKeys()
        loadampel()
        self.bestellungTV.reloadData()
        
        
    }
    
    
    override func viewDidLoad() {
        print(Barname, "kellnervc")
        loadampel()
        super.viewDidLoad()
        problemTextView.keyboardAppearance = UIKeyboardAppearance.dark
        problemTextView.alpha = 0.5
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        viewProblem.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
//        barnameLbl.text = Barname
        loadBestellungenKeys()
        
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        bestellungTV.refreshControl = refreshControl
    }
    
    
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        reload()
        sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
