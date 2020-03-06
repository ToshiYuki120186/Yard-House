//
//  mainVC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/25.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
var selectedIndex = 1

class mainVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    var bookingsVC : UIViewController!
    var homeVC : UIViewController!
    var accountVC : UIViewController!
    var tabItemVCs : [UIViewController]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard =  UIStoryboard.init(name: "main", bundle: nil)
        self.bookingsVC = storyBoard.instantiateViewController(withIdentifier: "bookingNav")//bookingNav , bookingsVC
        self.homeVC = storyBoard.instantiateViewController(withIdentifier: "homeNav")
        self.accountVC = storyBoard.instantiateViewController(withIdentifier: "accountNav")
        self.tabItemVCs = [bookingsVC,homeVC,accountVC]
        
        
        let storyboard = UIStoryboard(name: "main", bundle: nil)
        let navigationVC = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        
        let vc = tabItemVCs[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)

    }
   
    
    @IBAction func gotoTabItem(_ sender : UIButton){
        let index = sender.tag
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        if selectedIndex != previousIndex {
            let previousVC = tabItemVCs[previousIndex]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            let vc = tabItemVCs[selectedIndex]
            addChild(vc)
            vc.view.frame = contentView.bounds
            contentView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    

}
