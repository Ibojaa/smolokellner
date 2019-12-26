//
//  FertiggestelltVC.swift
//  SMOLO+
//
//  Created by Alper Maraz on 15.11.19.
//  Copyright © 2019 MAD. All rights reserved.
//

import UIKit
import Firebase



class FertiggestelltVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate, kellnerCellDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    
        // VARS

        var Barname = String()
        var KellnerID = String()
        var BestellungenSpeicher = [KellnerTVSection]()
        var Bestellungen = [KellnerTVSection]()
        var BestellungenFertig = [BestellungFertig]()
        var SplitRechnung = [BestellungFertig]()
        var filteredBestellungen = [KellnerTVSection]()
        var BestellungKategorien = [String: [String]]()
        var BestellungUnterkategorien = [String: [[String]]]()
        var BestellungExpanded2 = [String: [[Bool]]]()
        var BestellungItemsNamen = [String: [[[String]]]]()
        var BestellungItemsPreise = [String: [[[Double]]]]()
        var BestellungItemsKommentar = [String: [[[String]]]]()
        var BestellungItemsLiter = [String: [[[String]]]]()
        var BestellungenItemsExtrasNamen = [String: [[[[String]]]]]()
        var BestellungenItemsExtrasPreise = [String: [[[[Double]]]]]()
        var BestellungItemsMengen = [String: [[[Int]]]]()
    
        var Tischnummer = [String: String]()
        var Angenommen = [String: String]()
        var FromUserID = [String: String]()
        var TimeStamp = [String: Double]()
        var bestellungIDs = [String]()
        var extrasString = [String]()
        var extrasPreis = [Double]()
        let searchController = UISearchController(searchResultsController: nil)

        var ItemsPreis = [Double]()
        var ItemsMenge = [Double]()
        var ExtraPreis = [Double]()
        var gesamtpreislabel = 0.0
    
        // Abrechnung
        
        var SplitMenge = [String: Int]()

        var TischnummerIDs = [String: [String]]()
        
        var BestellungenBezahlen = [BestellungFertig]()
        
        @IBOutlet weak var aBezahlenBtn: UIButton!

        
        @IBOutlet weak var AbrechnenTV: UITableView!
    
    

    
        // OUTLETS
        

        @IBOutlet weak var fertigeBestellungenTV: UITableView!
        
    @IBOutlet weak var topView: UIView!
    
    //Searchfuncs
    func updateSearchResults(for searchController: UISearchController) {
          if searchController.isActive == true && searchController.searchBar.text != ""{
        filteredContent(searchText: searchController.searchBar.text!)
          }else{

            Bestellungen = BestellungenSpeicher
            //fertigeBestellungenTV.reloadData()
            self.reload()

        }
      }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Bestellungen = BestellungenSpeicher
        //reload()
        fertigeBestellungenTV.reloadData()
    }
    func filteredContent (searchText: String, scope: String = "All"){
          
          filteredBestellungen = Bestellungen.filter { bar in

              return ((bar.Tischnummer.lowercased().contains(searchText.lowercased())))
              
          }
        Bestellungen = filteredBestellungen
          fertigeBestellungenTV.reloadData()

      }
    
    // FUNCS

     func annehmen(sender: KellnerCell) {
              self.removeBestellung3(KellnerID: self.KellnerID, BestellungID:
                      self.Bestellungen[sender.Cell1Section].BestellungID)
    
        self.reload()
        }

        func removeBestellung3(KellnerID: String, BestellungID: String){
               var datref: DatabaseReference!
               datref = Database.database().reference()

                       datref.child("Bestellungen").child(self.Barname).child(BestellungID).child("Information").updateChildValues(["Status": "abrechnen"])
                       datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["Status": "abrechnen"])
                 
           }
        
        func loadBestellungenKeys(){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let bestellungInfos = BestellungInfos(dictionary: dictionary)
                    if bestellungInfos.Status == "fertig" {
                        self.bestellungIDs.append(snapshot.key)
                        
                        if self.TischnummerIDs[bestellungInfos.tischnummer!] == nil {
                            self.TischnummerIDs[bestellungInfos.tischnummer!] = [snapshot.key]
                        } else {
                            self.TischnummerIDs[bestellungInfos.tischnummer!]?.append(snapshot.key)
                        }
                        print(snapshot.key, bestellungInfos.tischnummer!,self.TischnummerIDs, "TischnummerIDS")
                        self.loadBestellungen(BestellungID: snapshot.key)
                        
                    }
                }
                
            }, withCancel: nil)
            
        }
        

        func loadBestellungen(BestellungID: String){
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
                                            if (newItems?.count)! < (self.BestellungKategorien[BestellungID]?.count)! {
                                                newItems?.append([[iteminfodic.itemName!]])
                                                newPreise?.append([[Double(iteminfodic.itemPreis!)]])
                                                newMengen?.append([[Int(iteminfodic.itemMenge!)]])
                                                newKommentare?.append([[iteminfodic.itemKommentar!]])
                                                newLiters?.append([[iteminfodic.itemLiter!]])
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiters
                                                } else {
                                                var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                                newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiters
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
                                            var newnewItem = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            var newnewLiters = newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                            if newnewItem.count < newx.count {
                                                newnewItem.append([iteminfodic.itemName!])
                                                newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                                newnewMengen.append([iteminfodic.itemMenge!])
                                                newnewKommentare.append([iteminfodic.itemKommentar!])
                                                newnewLiters.append([iteminfodic.itemLiter!])
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiter
                                            } else {
                                                newnewItem[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                                newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItem
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiter![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiter
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
                                                var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                let newx = x![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                if newnewItems.count < newx.count {
                                                    newnewItems.append([iteminfodic.itemName!])
                                                    newnewPreise.append([Double(iteminfodic.itemPreis!)])
                                                    newnewMengen.append([iteminfodic.itemMenge!])
                                                    newnewKommentare.append([iteminfodic.itemKommentar!])
                                                    newnewLiters.append([iteminfodic.itemLiter!])
                                                    newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                    newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                    newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                    newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                    newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                    self.BestellungItemsNamen[BestellungID] = newItems
                                                    self.BestellungItemsPreise[BestellungID] = newPreise
                                                    self.BestellungItemsMengen[BestellungID] = newMengen
                                                    self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                    self.BestellungItemsLiter[BestellungID] = newLiters
                                                    } else {
                                                    newnewItems[newx.index(of: children.key)!].append(iteminfodic.itemName!)
                                                    newnewPreise[newx.index(of: children.key)!].append(Double(iteminfodic.itemPreis!))
                                                    newnewMengen[newx.index(of: children.key)!].append(iteminfodic.itemMenge!)
                                                    newnewKommentare[newx.index(of: children.key)!].append(iteminfodic.itemKommentar!)
                                                    newnewLiters[newx.index(of: children.key)!].append(iteminfodic.itemLiter!)
                                                    newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                    newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                    newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                    newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                    newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                    self.BestellungItemsNamen[BestellungID] = newItems
                                                    self.BestellungItemsPreise[BestellungID] = newPreise
                                                    self.BestellungItemsMengen[BestellungID] = newMengen
                                                    self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                    self.BestellungItemsLiter[BestellungID] = newLiters
                                                }}}}
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
                                                            var a = self.BestellungUnterkategorien[BestellungID]!
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
                                                var newnewItems = newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewPreise = newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewMengen = newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewKommentare = newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                var newnewLiters = newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!]
                                                newnewItems[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemName!)
                                                newnewPreise[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(Double(iteminfodic.itemPreis!))
                                                newnewMengen[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemMenge!)
                                                newnewKommentare[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemKommentar!)
                                                newnewLiters[(self.BestellungUnterkategorien[BestellungID]?.index(of: [children.key]))!].append(iteminfodic.itemLiter!)
                                                newItems![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewItems
                                                newPreise![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewPreise
                                                newMengen![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewMengen
                                                newKommentare![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewKommentare
                                                newLiters![(self.BestellungKategorien[BestellungID]?.index(of: key.key))!] = newnewLiters
                                                self.BestellungItemsNamen[BestellungID] = newItems
                                                self.BestellungItemsPreise[BestellungID] = newPreise
                                                self.BestellungItemsMengen[BestellungID] = newMengen
                                                self.BestellungItemsKommentar[BestellungID] = newKommentare
                                                self.BestellungItemsLiter[BestellungID] = newLiters
                                                } else {
                                                self.BestellungItemsNamen.updateValue([[[iteminfodic.itemName!]]], forKey: BestellungID)
                                                self.BestellungItemsPreise.updateValue([[[Double(iteminfodic.itemPreis!)]]], forKey: BestellungID)
                                                self.BestellungItemsMengen.updateValue([[[iteminfodic.itemMenge!]]], forKey: BestellungID)
                                                self.BestellungItemsKommentar.updateValue([[[iteminfodic.itemKommentar!]]], forKey: BestellungID)
                                                self.BestellungItemsLiter.updateValue([[[iteminfodic.itemLiter!]]], forKey: BestellungID)
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
                if self.bestellungIDs.count == self.BestellungKategorien.count {
                    for i in 0..<self.bestellungIDs.count {
                        self.setSectionsKellnerBestellung(BestellungID: self.bestellungIDs[i], tischnummer: self.Tischnummer[self.bestellungIDs[i]]!, fromUserID: self.FromUserID[self.bestellungIDs[i]]!, TimeStamp: self.TimeStamp[self.bestellungIDs[i]]!, Kategorie: self.BestellungKategorien[self.bestellungIDs[i]]!, Unterkategorie: self.BestellungUnterkategorien[self.bestellungIDs[i]]!, items: self.BestellungItemsNamen[self.bestellungIDs[i]]!, preis: self.BestellungItemsPreise[self.bestellungIDs[i]]!, liter: self.BestellungItemsLiter[self.bestellungIDs[i]]!, extras: self.BestellungenItemsExtrasNamen[self.bestellungIDs[i]]!, extrasPreis: self.BestellungenItemsExtrasPreise[self.bestellungIDs[i]]!, kommentar: self.BestellungItemsKommentar[self.bestellungIDs[i]]!, menge: self.BestellungItemsMengen[self.bestellungIDs[i]]!, expanded2: self.BestellungExpanded2[self.bestellungIDs[i]]!, expanded: false)
                        
                        if self.Bestellungen.count == self.bestellungIDs.count{
                            self.BestellungenZusammenführen()
//                            self.fertigeBestellungenTV.reloadData()
                        }
                    }
                }
            }
    }
        
        
    func BestellungenZusammenführen(){
        var ids = [String]()
        var AlleItems = [String]()
        var AllePreise = [Double]()
        var AlleMengen = [Int]()
        var BezahltMengen = [Int]()
        var Kategorien = [String]()
        
        
        for tisch in TischnummerIDs.keys {
            for bestellung in Bestellungen{
                if bestellung.Tischnummer == tisch {
                    print(tisch, bestellung.BestellungID, "print dies das")
                    ids.append(bestellung.BestellungID)
                    
                    for items in bestellung.items{
                        for item in items{
                            AlleItems.append(contentsOf: item)
                            }
                        }
                    
                    for preise in bestellung.preis{
                    for preis in preise{
                        AllePreise.append(contentsOf: preis)
                        BezahltMengen.append(0)
                        }
                    }
                    
                    for mengen in bestellung.menge{
                    for menge in mengen{
                        AlleMengen.append(contentsOf: menge)
                        }
                    }
                    
                    for kategorie in bestellung.Kategorie {
                        if !Kategorien.contains(kategorie) {
                            Kategorien.append(kategorie)
                            }
                        }
                }
            
            }
            print(ids, "ids gleiche nummer")
            print(AlleItems, "alle Items")
            setSectionsBestellungenFertig(BestellungID: ids, tischnummer: tisch, fromUserID: "kommt noch", TimeStamp: [0, 0], Kategorie: Kategorien, items: AlleItems, preis: AllePreise, menge: AlleMengen, bezahltMenge: BezahltMengen, expanded: false)
            
            ids.removeAll()
            AlleItems.removeAll()
            AllePreise.removeAll()
            AlleMengen.removeAll()
            Kategorien.removeAll()
            BezahltMengen.removeAll()
            fertigeBestellungenTV.reloadData()
            
            print(self.BestellungenFertig, "Fertige BEstellungen")
        }
        
        
    }
        func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, fromUserID: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool){
            self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, extras: extras, extrasPreis: extrasPreis, kommentar: kommentar, menge: menge, expanded2: expanded2, expanded: expanded))
        }
    
    func setSectionsBestellungenFertig(BestellungID: [String], tischnummer: String, fromUserID: String, TimeStamp: [Double], Kategorie: [String], items: [String], preis: [Double], menge: [Int], bezahltMenge: [Int], expanded: Bool){
        self.BestellungenFertig.append(BestellungFertig(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, Kategorie: Kategorie, items: items, preis: preis, menge: menge, bezahltMenge: bezahltMenge, expanded: expanded))
           }
    
        
        //
        //        func removeBestellung(KellnerID: String, BestellungID: String){
        //            var datref: DatabaseReference!
        //            datref = Database.database().reference()
        //            datref.child("userBestellungen").child(KellnerID).child(BestellungID).updateChildValues(["angenommen": true])
        //        }
        //
        
        // TABLE
        
        func numberOfSections(in tableView: UITableView) -> Int {
            var numberOfSection: Int?
            if tableView == fertigeBestellungenTV {
            numberOfSection = self.BestellungenFertig.count
                }
            if tableView == AbrechnenTV {
                numberOfSection = 1

            }
            return numberOfSection!
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var numberOfRowsInSection: Int?
            if tableView == fertigeBestellungenTV {
                print(BestellungenFertig,  "bestellguengen fertog")
                       numberOfRowsInSection = self.BestellungenFertig[section].items.count
                           }
            if tableView == AbrechnenTV {
                           if  BestellungenBezahlen.count != 0{
                           numberOfRowsInSection = BestellungenBezahlen[0].items.count
                           } else {
                            numberOfRowsInSection = 0                           }
                print(numberOfRowsInSection, 2222222)

                       }

            return numberOfRowsInSection!
        }
        
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            var heightForHeaderInSection: Int?
            heightForHeaderInSection = 36
            print(heightForHeaderInSection, 33333)

            return CGFloat(heightForHeaderInSection!)
            
        }
        
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var heightForRow: Int?
          if tableView == fertigeBestellungenTV {
            if (BestellungenFertig[indexPath.section].expanded) {
                heightForRow = 36
            }
            else {
                heightForRow = 0
            }
            }
        if tableView == AbrechnenTV {
            heightForRow = 36
            
            }
            return CGFloat(heightForRow!)
            }
        
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            
            var heightForFooterInSection: Int?
            
            if tableView == fertigeBestellungenTV {
                       if (BestellungenFertig[section].expanded) {
                           heightForFooterInSection = 50
                       }
                       else {
                           heightForFooterInSection = 15
                       }
                
            }
            if tableView == AbrechnenTV {
                           heightForFooterInSection = 15
                       }
            
            return CGFloat(heightForFooterInSection!)
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            switch tableView {
            case fertigeBestellungenTV:
                let allesBezahlenBtn = CustomButton()
                print(section, "3456zhvcdrtzhbvftzuj")
                allesBezahlenBtn.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
                allesBezahlenBtn.customObject = section
                allesBezahlenBtn.setTitle("Alles bezahlen", for: .normal)
                allesBezahlenBtn.center.x = tableView.center.x
                allesBezahlenBtn.addTarget(self, action: #selector(self.allesBezahlen(_:)), for: .touchUpInside)
                view.addSubview(allesBezahlenBtn)
            default: break
                }

            return view
        }

        
    @objc public func allesBezahlen(_ sender: CustomButton) {
        
        let FooterSection = sender.customObject

        BestellungenBezahlen.removeAll()
        print(BestellungenBezahlen, "bestellungenbezahlen")
        BestellungenFertig[FooterSection!].bezahltMenge = BestellungenFertig[FooterSection!].menge
        BestellungenBezahlen.append(BestellungenFertig[FooterSection!])
        print(BestellungenBezahlen, "bestellungenbezahlen")
        AbrechnenTV.reloadData()
    }
    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            
            let header = ExpandableHeaderView()
            header.contentView.layer.cornerRadius = 10
            header.contentView.layer.backgroundColor = UIColor.clear.cgColor
            header.layer.cornerRadius = 10
            header.layer.backgroundColor = UIColor.clear.cgColor
            if tableView == fertigeBestellungenTV {
            header.customInit(tableView: tableView, title: BestellungenFertig[section].Tischnummer, section: section, delegate: self as ExpandableHeaderViewDelegate)
                
            }
            if tableView == AbrechnenTV {
                if BestellungenBezahlen.count > 0 {
                    header.customInit(tableView: tableView, title: BestellungenBezahlen[0].Tischnummer, section: section, delegate: self as ExpandableHeaderViewDelegate)
                }
                
            }
            return header
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Bundle.main.loadNibNamed("BestellungFertigCell", owner: self, options: nil)?.first as! BestellungFertigCell
            switch tableView {
            case fertigeBestellungenTV:
                cell.itemLBl.text = BestellungenFertig[indexPath.section].items[indexPath.row]
                cell.mengeLbl.text = "\(BestellungenFertig[indexPath.section].bezahltMenge[indexPath.row])/\(BestellungenFertig[indexPath.section].menge[indexPath.row])"
                for item in BestellungenFertig[indexPath.section].items {
                    SplitMenge.updateValue(0, forKey: item)
                
                }
            case AbrechnenTV:
                           if  BestellungenBezahlen.count > 0{
                           cell.itemLBl.text = BestellungenBezahlen[0].items[indexPath.row]
                           cell.mengeLbl.text = "\(BestellungenBezahlen[0].bezahltMenge[indexPath.row])"
                }
            default:
               print("sorrry")
                
            }
            print(SplitMenge, "CellforRow")
            return cell

        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == fertigeBestellungenTV {
//
//        let id = BestellungenFertig[indexPath.section].BestellungID
//        let tischnummer = BestellungenFertig[indexPath.section].Tischnummer
//        let fromuserid = BestellungenFertig[indexPath.section].fromUserID
//        let kategorie = BestellungenFertig[indexPath.section].Kategorie
//        let items = BestellungenFertig[indexPath.section].items[indexPath.row]
//        let preis = BestellungenFertig[indexPath.section].preis[indexPath.row]
//        let menge = BestellungenFertig[indexPath.section].menge[indexPath.row]

        self.BestellungenBezahlen.removeAll()
            self.BestellungenBezahlen = [self.BestellungenFertig[indexPath.section]]
        AbrechnenTV.reloadData()

//            if SplitMenge[items]! < menge {
//            self.SplitMenge[items]! = (self.SplitMenge[items]!)+1
//                print("reloaddidselect")
//            }
//        }
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
            if tableView == fertigeBestellungenTV {
                 BestellungenFertig[section].expanded = !BestellungenFertig[section].expanded
//            for i in 0..<Bestellungen.count{
//                if i == section {
//                    Bestellungen[section].expanded = !Bestellungen[section].expanded
//                } else {
//                    Bestellungen[i].expanded = false
//
//                }
//            }

            fertigeBestellungenTV.beginUpdates()
            fertigeBestellungenTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)

            fertigeBestellungenTV.endUpdates()
            
        }
    }
        
        // OTHERS
        
        
        override func viewDidLoad() {

            super.viewDidLoad()
       
            
            let background = UIImage(named: "hintergrund")

                var imageView : UIImageView!
                imageView = UIImageView(frame: view.bounds)
                imageView.contentMode =  UIViewContentMode.scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = background
                imageView.center = view.center
                view.addSubview(imageView)
                self.view.sendSubview(toBack: imageView)
        
            loadBestellungenKeys()
            
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
            fertigeBestellungenTV.refreshControl = refreshControl
            
            searchController.searchBar.placeholder = "Finde deine SMOLO"
            searchController.searchBar.barTintColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            searchController.searchBar.searchBarStyle = .prominent
            searchController.searchBar.tintColor = .white

            if let txfSearchField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                txfSearchField.textColor = .white
                txfSearchField.borderStyle = .roundedRect
                txfSearchField.backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
            }
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation  = false
            definesPresentationContext = true
            //BarTV.tableHeaderView = searchController.searchBar
            searchController.searchBar.delegate = self
                // Add the search bar as a subview of the UIView you added above the table view
            self.topView.addSubview(self.searchController.searchBar)
            // Call sizeToFit() on the search bar so it fits nicely in the UIView
            self.searchController.searchBar.sizeToFit()
            // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
            self.searchController.searchBar.frame.size.width = self.view.frame.size.width
            BestellungenSpeicher = Bestellungen
            
        }
        func reload(){
            print("wrefrgtedws")
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
            BestellungenFertig.removeAll()
            Tischnummer.removeAll()
            Angenommen.removeAll()
            FromUserID.removeAll()
            TimeStamp.removeAll()
            loadBestellungenKeys()
            self.fertigeBestellungenTV.reloadData()
            //
            
        }
        
        @objc private func refreshOptions(sender: UIRefreshControl) {
            
            reload()
            sender.endRefreshing()
            
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

        
    }

class CustomButton : UIButton {

    var customObject : Int?

    convenience init(object: Int) {
        self.init()
        self.customObject = object
    }
}
