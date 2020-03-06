//
//  campVC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/16/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftMessages

class campVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
  
    @IBOutlet var mainView: UIView!
    var service : serviceType!
    
    @IBOutlet weak var titleBig: UILabel!
    @IBOutlet weak var titleSmall: UILabel!
    
    var camps = [Camp]()
    var currentSelectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.camps = sharedData.initialData.camps
        self.containerViewHeight.constant = CGFloat(self.camps.count * 90 + 10)
        self.titleBig.text = "CAMPS & CLINICS"
        self.titleSmall.text = "Fall is here and it's time to develop those skills as the offseason begins! Instructed by both players and coach's of COMBA's College Prep 18U High Performance Program, our skill development options include:"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        
        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        self.mainView.backgroundColor = appColors.appBackgroundColor
        
    }
    
    func payment( selectedCamp : Camp ) {
        
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_paymentVC") as! page_paymentVC
        
        vc.campId = selectedCamp.id
        vc.service = .camp
        vc.totalamountInt = Double(selectedCamp.price)
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
    }
    
}

extension campVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.camps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "page_1Cell", for: indexPath) as! page_1Cell
        cell.selectionStyle = .none
        let camp = self.camps[indexPath.row]
        
        var url_str = camp.image
        cell.itemName.text = camp.name
        
        let url = URL(string: url_str)
        let processor = DownsamplingImageProcessor(size: cell.iconImg.frame.size) |> RoundCornerImageProcessor(cornerRadius: 5)
        cell.iconImg.kf.indicatorType = .activity
        cell.iconImg.kf.setImage(with: url, placeholder: UIImage(named: "mainLogoWithColor.png"), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let view: TacoDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.camp = self.camps[indexPath.row]
        view.getTacosAction = { camp in
            self.payment(selectedCamp: camp)
            SwiftMessages.hide() }
        view.cancelAction = {
            SwiftMessages.hide() }
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
}



