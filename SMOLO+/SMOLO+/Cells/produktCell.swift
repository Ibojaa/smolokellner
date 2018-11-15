//
//  produktCell.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 05.11.18.
//  Copyright © 2018 MAD. All rights reserved.
//


import UIKit

protocol produktCellDelegate {
    func pass(sender: produktCell)
    func reloadUnterkategorien(sender: produktCell)
    func reloadTable(sender: produktCell)
}

class produktCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate, produktCellDelegate2, ExpandableHeaderViewDelegate2 {
    func verfuegbarBtnTapped(sender: produktCell2) {
        //        produktTV.beginUpdates()
        section2 = sender.section2
        row2 = sender.row2
        delegate?.pass(sender: self)
        delegate?.reloadUnterkategorien(sender: self)
        //        produktTV.reloadRows(at: [IndexPath(row: sender.row2, section: sender.section2)], with: .automatic)
        //        produktTV.endUpdates()
    }
    
    
    // VARS
    var delegate: produktCellDelegate?
    var unterkategorien = [ExpandTVSection2]()
    var items = [[String]]()
    var verfuegbarkeit = [[Bool]]()
    var section = Int()
    var row = Int()
    
    var section2 = Int()
    var row2 = Int()
    
    var cellIndexPathSection: Int!
    
    
    // OUTLETS
    
    @IBOutlet weak var produktTV: UITableView!
    
    // TableView FUNCS
    func numberOfSections(in tableView: UITableView) -> Int {
        return unterkategorien[cellIndexPathSection].Unterkategorie.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return unterkategorien[cellIndexPathSection].items[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if unterkategorien[cellIndexPathSection].expanded2[indexPath.section] != false {
            return CGFloat(46)
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
        let header = ExpandableHeaderView2()
        header.customInit(tableView: tableView, title:  unterkategorien[cellIndexPathSection].Unterkategorie[section], section: section, delegate: self as ExpandableHeaderViewDelegate2)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("produktCell2", owner: self, options: nil)?.first as! produktCell2
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        //        cell.itemLbl.text = "cell.itemLbl.text"
        if unterkategorien[cellIndexPathSection].expanded2[indexPath.section] != false {
            
            var item = unterkategorien[cellIndexPathSection].items[indexPath.section]
            var verfuegbarkeit = unterkategorien[cellIndexPathSection].verfuegbarkeit[indexPath.section]
            section2 = indexPath.section
            row2 = indexPath.row
            cell.section2 = indexPath.section
            cell.row2 = indexPath.row
            cell.itemNameLbl.text = item[indexPath.row]
            cell.verfuegbarBtn.tintColor = UIColor.white
            if verfuegbarkeit[indexPath.row] {
                cell.verfuegbarBtn.isSelected = false
            } else {
                cell.verfuegbarBtn.isSelected = true
                
            }
            return cell
            
        } else {
            cell.itemNameLbl.isHidden = true
            cell.verfuegbarBtn.isHidden = true
            
            return cell
        }
    }
    
    
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView2, section: Int) {
        
        for i in 0..<unterkategorien[cellIndexPathSection].Unterkategorie.count{
            if i == section {
                unterkategorien[cellIndexPathSection].expanded2[i] = !unterkategorien[cellIndexPathSection].expanded2[i]
            } else {
                unterkategorien[cellIndexPathSection].expanded2[i] = false
                
            }
        }
        
        produktTV.beginUpdates()
        let indexSet = NSMutableIndexSet()
        for i in 0..<unterkategorien[cellIndexPathSection].items[section].count {
            produktTV.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        for i in 0..<unterkategorien[cellIndexPathSection].Unterkategorie.count{
            if i != section{
                indexSet.add(i)}
        }
        produktTV.reloadSections(indexSet as IndexSet, with: .automatic)
        delegate?.reloadTable(sender: self)
        produktTV.endUpdates()
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        produktTV.delegate = self
        produktTV.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
