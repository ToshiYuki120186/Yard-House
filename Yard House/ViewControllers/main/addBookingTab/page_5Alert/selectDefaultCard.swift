//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages

class selectDefaultCard: MessageView {
    

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var cellHeight = 60
    
    
    override  func awakeFromNib() {
        
        self.tableViewHeight.constant = CGFloat(sharedData.userData.stripeCards.count * self.cellHeight)
        self.tableView.register(UINib(nibName: "selectDefaultCardCell", bundle: nil), forCellReuseIdentifier: "selectDefaultCardCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
    }

  
    var selectRow : ((_ count: Int) -> Void)?
  
}

extension selectDefaultCard : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedData.userData.stripeCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "selectDefaultCardCell", for: indexPath) as! selectDefaultCardCell
        
        cell.selectionStyle = .none
        let card = sharedData.userData.stripeCards[indexPath.row]
        
        cell.cellBack.layer.cornerRadius = 3
        cell.cellBack.layer.borderColor = UIColor.lightGray.cgColor
        cell.cellBack.layer.borderWidth = 1
        
        cell.brand.text = card.brand
        
        cell.exp.text = "Ending in \(card.last4) (expires on \(card.expMonth)/\(card.expYear))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.cellHeight)
    }
    
    
}
