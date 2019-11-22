import UIKit
import Firebase

class DetailKatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate, DropDownBtnProtocoll, FilterBtnDelegate {
    func passKatsBtn(sender: DropDownBtn) {
        DropDownKats = sender.DropDownKatsBtn
        print(DropDownKats, "DDK")

        
    }
    
    
    
    func FilternBtnTapped() {
        print("HIIIII")
        Button.dismissDropDown()
        dismissFilternBtn()
        print(DropDownKats)
        
    }
    
    // VARS
    
    var showKat = String()
    var DropDownKats = [String: Bool]()
    var Button = DropDownBtn()
    var FilternBtn = FilterBtn()
    var IDfilter = [String: Bool]()
    var Barname = String()
    var KellnerID = String()
    
    var Bestellungen = [KellnerTVSection]()
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
    
    // OUTLETS
    

    @IBOutlet weak var angenommenBestellungenTV: UITableView!
    
    
    // FUNCS
    func passShowKat() {
        showKat = Button.showKatBtn
        print(showKat, "showkat")
        reload()
    }
    func dismissFilternBtn() {
        if self.view.subviews.contains(FilternBtn) {
            self.view.viewWithTag(1000)?.removeFromSuperview()
        }
    }
    func showFilternBtn() {
        
        if !self.view.subviews.contains(FilternBtn){
            self.view.addSubview(FilternBtn)
            FilternBtn.tag = 1000
            FilternBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            FilternBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 200).isActive = true
            FilternBtn.widthAnchor.constraint(equalToConstant: 230).isActive = true
            FilternBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true

        }
    }
    
    func getKategorien (){
            var datref: DatabaseReference!
            datref = Database.database().reference()
            
        datref.child("Speisekarten").child("\(self.Barname)").observeSingleEvent(of: .value, with: { (snapshotKategorie) in
            for key in (snapshotKategorie.children.allObjects as? [DataSnapshot])! {
                print(key.key, "keykey")
                self.DropDownKats[key.key] = false
                    }
            self.Button.DropView.DropDownKatsView = self.DropDownKats
            self.Button.DropView.DropDownTV.reloadData()

        }, withCancel: nil)
        
        }
    
    
    func loadBestellungenKeys(){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("userBestellungen").child(KellnerID).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bestellungInfos = BestellungInfos(dictionary: dictionary)
                if bestellungInfos.Status == "angenommen" {
                    self.appendID(bestellungID: snapshot.key)
                    self.IDfilter[snapshot.key] = false
                    self.loadBestellungen(BestellungID: snapshot.key)
                }
            }
        
        }, withCancel: nil)
        
    }
    func appendID(bestellungID: String){
        self.bestellungIDs.append(bestellungID)
    }
    
    func loadBestellungen(BestellungID: String){
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Bestellungen").child(Barname).child(BestellungID).observeSingleEvent(of: .value) { (snapshot) in
            
            for key in (snapshot.children.allObjects as? [DataSnapshot])! {
                print(self.showKat, key.key, "keykey1")
                if key.key == "Information" {
                    if let dictionary = key.value as? [String: AnyObject]{
                        let bestellungInfos = BestellungInfos(dictionary: dictionary)
                        self.Tischnummer.updateValue(bestellungInfos.tischnummer!, forKey: BestellungID)
                        self.FromUserID.updateValue(bestellungInfos.fromUserID!, forKey: BestellungID)
                        self.TimeStamp.updateValue(bestellungInfos.timeStamp!, forKey: BestellungID) }}
//                else if key.key != self.showKat{
//                    if !self.noID.contains(BestellungID){
//                        self.noID.append(BestellungID)
//                    }
//                }
                else if key.key == self.showKat {
                    print(self.showKat, key.key, "keykey2")
                    self.IDfilter[BestellungID] = true
//                    self.IDFilter.append(BestellungID)
                    
                    print(BestellungID, "printID")
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
//            print(self.noID, self.IDFilter, self.bestellungIDs, self.BestellungKategorien, "IDsundKats")
//            var IDFilterCount = [Bool]()
//            for id in self.bestellungIDs {
//
//            }
//            if self.IDfilter.count == self.bestellungIDs.count{
//            for (ID, value) in self.IDfilter {
//                if value == true {
//                    IDFilterCount.append(value) }
//                }}
            let trueID = self.IDfilter.filter { $0.value }
            let falseID = self.IDfilter.filter { !$0.value }

            print(self.IDfilter, trueID, falseID, self.BestellungKategorien, "filtercount")
            print(trueID, "true id")
            self.Bestellungen.removeAll()
            if self.IDfilter.count - falseID.count == self.BestellungKategorien.count{
                
                print(self.bestellungIDs, self.BestellungKategorien,  "doppeltebestellung")
                for (id, _) in trueID {
                        
                        self.setSectionsKellnerBestellung(BestellungID: id, tischnummer: self.Tischnummer[id]!, fromUserID: self.FromUserID[id]!, TimeStamp: self.TimeStamp[id]!, Kategorie: self.BestellungKategorien[id]!, Unterkategorie: self.BestellungUnterkategorien[id]!, items: self.BestellungItemsNamen[id]!, preis: self.BestellungItemsPreise[id]!, liter: self.BestellungItemsLiter[id]!, extras: self.BestellungenItemsExtrasNamen[id]!, extrasPreis: self.BestellungenItemsExtrasPreise[id]!, kommentar: self.BestellungItemsKommentar[id]!, menge: self.BestellungItemsMengen[id]!, expanded2: self.BestellungExpanded2[id]!, expanded: false)
                
                }
                print(self.Bestellungen.count, trueID, "bestellung und filter count")
                                  if self.Bestellungen.count == trueID.count {
                                      self.angenommenBestellungenTV.reloadData()
                                  }
            }
        }}
    func setSectionsKellnerBestellung(BestellungID: String, tischnummer: String, fromUserID: String, TimeStamp: Double, Kategorie: [String], Unterkategorie: [[String]], items: [[[String]]], preis: [[[Double]]], liter: [[[String]]], extras: [[[[String]]]], extrasPreis: [[[[Double]]]], kommentar: [[[String]]], menge: [[[Int]]], expanded2: [[Bool]], expanded: Bool){
        self.Bestellungen.append(KellnerTVSection(BestellungID: BestellungID, tischnummer: tischnummer, fromUserID: fromUserID, timeStamp: TimeStamp, Kategorie: Kategorie, Unterkategorie: Unterkategorie, items: items, preis: preis, liter: liter, extras: extras, extrasPreis: extrasPreis, kommentar: kommentar, menge: menge, expanded2: expanded2, expanded: expanded))
//        IDgefiltert.append(BestellungID)
        print(BestellungID,"printBestellung")
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
        print(self.Bestellungen, "bestellungen")
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
        header.contentView.layer.cornerRadius = 10
        header.contentView.layer.backgroundColor = UIColor.clear.cgColor
        header.layer.cornerRadius = 10
        header.layer.backgroundColor = UIColor.clear.cgColor
        
        header.customInit(tableView: tableView, title: Bestellungen[section].Tischnummer, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("KellnerCell", owner: self, options: nil)?.first as! KellnerCell
        cell.Bestellungen = Bestellungen
        cell.Cell1Section = indexPath.section
        cell.bestellungID = Bestellungen[indexPath.section].BestellungID
        
        
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
        var ItemsPreis = 0.0
        var ExtraPreis = 0.0
        
//        for itemsPreise in  Bestellungen[indexPath.section].preis {
//            var mengen = Bestellungen[indexPath.section].menge
//
//            for itemPreise in itemsPreise {
//
//                for preis in itemPreise {
//                    ItemsPreis = ItemsPreis + preis
//                }
//
//            }
//        }
//
        for extrasPreise in Bestellungen[indexPath.section].extrasPreis {
            for extrasPreis in extrasPreise {
                for extraPreis in extrasPreis {
                    for preis in extraPreis {
                        ExtraPreis = ExtraPreis + preis
                    }
                }
            }
        }
        
        cell.gesamtPreisLbl.text = "\(ExtraPreis+ItemsPreis) €"
        
        ItemsPreis = 0.0
        ExtraPreis = 0.0
        return cell
    }
    
    
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView, section: Int) {
        for i in 0..<Bestellungen.count{
            if i == section {
                Bestellungen[section].expanded = !Bestellungen[section].expanded
            } else {
                Bestellungen[i].expanded = false
                
            }
        }
        
        angenommenBestellungenTV.beginUpdates()
        angenommenBestellungenTV.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        
        angenommenBestellungenTV.endUpdates()
        
    }
    
    // OTHERS
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        getKategorien()
        Button = DropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        Button.setTitle("Bereich", for: .normal)
        showKat = "Shishas"
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.delegate = self

        self.view.addSubview(Button)
        
        Button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        Button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        Button.widthAnchor.constraint(equalToConstant: 230).isActive = true
        Button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)

        loadBestellungenKeys()
        
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("aktualisiere", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        angenommenBestellungenTV.refreshControl = refreshControl
        
        FilternBtn = FilterBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        FilternBtn.setTitle("Filtern", for: .normal)
        FilternBtn.translatesAutoresizingMaskIntoConstraints = false
        FilternBtn.delegate = self
        
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
        Tischnummer.removeAll()
        Angenommen.removeAll()
        FromUserID.removeAll()
        TimeStamp.removeAll()
        loadBestellungenKeys()
        self.angenommenBestellungenTV.reloadData()
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





protocol DropDownProtocoll {
    func DropDownPressed(string: String)
    func passKatsView(sender: DropDownView)
}
protocol DropDownBtnProtocoll {
    func passShowKat()
    func showFilternBtn()
    func passKatsBtn(sender: DropDownBtn)
    
}


class DropDownBtn: UIButton, DropDownProtocoll {
    func passKatsView(sender: DropDownView) {
        DropDownKatsBtn = sender.DropDownKatsView
        delegate.passKatsBtn(sender: self)
        print(DropDownKatsBtn, "DDKBtn")

    }
    
    
    func DropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        showKatBtn = string
        self.delegate.passShowKat()
        
    }
    
    
    var DropView = DropDownView()
    var showKatBtn = String()
    var delegate: DropDownBtnProtocoll!
    var DropDownKatsBtn = [String: Bool]()
    var height = NSLayoutConstraint()
    
    var isOpen = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray

        DropView = DropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        DropView.delegate = self
        DropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(DropView)
        self.superview?.bringSubview(toFront: DropView)
        
        DropView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        DropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        DropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = DropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.showFilternBtn()
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if self.DropView.DropDownTV.contentSize.height > 220 {
                    self.height.constant = 220
            } else {
                self.height.constant = self.DropView.DropDownTV.contentSize.height
            }
            
            self.height.constant = 220
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.DropView.layoutIfNeeded()
                self.DropView.center.y += self.DropView.frame.height/2
            }, completion: nil)
        }
    }
    
    func dismissDropDown(){
        
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.DropView.center.y -= self.DropView.frame.height/2
            self.DropView.layoutIfNeeded()
        }, completion: nil)
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource, FilterCellDelegate {
    
    func passKatsCell(sender: FilterCell) {
        DropDownKatsView = sender.DropDownKatsCell
        delegate.passKatsView(sender: self)
        
        
        print(DropDownKatsView, "DDKView")

    }
    
    
    
    
    var DropDownKatsView = [String: Bool]()
    var DropDownTV = UITableView()
    var delegate: DropDownProtocoll!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DropDownTV.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        DropDownTV.delegate = self
        DropDownTV.dataSource = self
        
        DropDownTV.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(DropDownTV)
        
        DropDownTV.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        DropDownTV.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        DropDownTV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        DropDownTV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        DropDownTV.allowsSelection = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DropDownKatsView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FilterCell", owner: self, options: nil)?.first as! FilterCell

        cell.filterLbl.text = Array(DropDownKatsView)[indexPath.row].key
        cell.DropDownKatsCell = DropDownKatsView
        cell.FilterRow = indexPath.row
        cell.backgroundColor = UIColor.darkGray
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.DropDownPressed(string: Array(DropDownKatsView)[indexPath.row].key)
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        DropDownTV.delegate = self
        DropDownTV.dataSource = self
    }
    
}

protocol FilterBtnDelegate {
    func FilternBtnTapped()
}
class FilterBtn: UIButton {
    
    var delegate: FilterBtnDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
    }
    
    override func didMoveToSuperview() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Holaaaa")
        delegate?.FilternBtnTapped()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
