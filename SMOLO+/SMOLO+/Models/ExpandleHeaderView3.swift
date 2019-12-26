//
//  ExpandleHeaderView3.swift
//  SMOLO+
//
//  Created by Ibrahim Akcam on 18.10.18.
//  Copyright © 2018 MAD. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate3 {
    func toggleSection(tableView: UITableView, header: ExpandableHeaderView3, section: Int)
}

class ExpandableHeaderView3: UITableViewHeaderFooterView {
    
    
    var delegate: ExpandableHeaderViewDelegate3?
    var section: Int!
    var tableView = UITableView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        
        let cell = gestureRecognizer.view as! ExpandableHeaderView3
        delegate?.toggleSection(tableView: tableView, header: self, section: cell.section)
    }
    
    func customInit(tableView: UITableView, title: String, section: Int, delegate: ExpandableHeaderViewDelegate3) {
        
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
        self.tableView = tableView
        self.tableView.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView?.backgroundColor = UIColor.clear
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.font = UIFont(name: "Verdana-Bold", size: 18.0)
        self.textLabel?.textAlignment = .left
        self.textLabel?.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.tableView.headerView(forSection: self.section)?.backgroundView?.backgroundColor = UIColor.clear
        self.tableView.headerView(forSection: self.section)?.layer.backgroundColor = UIColor.clear.cgColor
        self.textLabel?.frame = self.layer.frame

        
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
