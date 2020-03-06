//
//  membershipVC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/16/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class membershipVC: ButtonBarPagerTabStripViewController {

    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet weak var titleBig: UILabel!
    @IBOutlet weak var titleSmall: UILabel!
    
    var viewcontrollers : [UIViewController]!
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    override func viewDidLoad() {
        

        self.titleBig.text = "Memberships"
        self.titleSmall.text = "We offer two types of membership.Our MVP members have exclusive access to our gym. Platinum members have access to our gym and batting cages during Member Hours. Join today to take advantage of membership perks."
        
        self.container.layer.borderColor = UIColor
            .lightGray.cgColor
        self.container.layer.borderWidth = 1
        
        self.mainView.backgroundColor = appColors.appBackgroundColor
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = appColors.appMainColorForGradient
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 18)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 5
        settings.style.buttonBarRightContentInset = 5
        

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .darkGray
            oldCell?.backgroundColor = .clear
            newCell?.backgroundColor = .clear
            newCell?.label.textColor = appColors.appMainColorForGradient
        }
   
        
        super.viewDidLoad()
        
    }
    
      override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyBoard = UIStoryboard.init(name: "main", bundle: nil)
        let mvpVC = storyBoard.instantiateViewController(withIdentifier: "MVPVC") as! MVPVC
        mvpVC.itemInfo = "MVP"
        let platinum = storyBoard.instantiateViewController(withIdentifier: "platinumVC") as! platinumVC
        platinum.itemInfo = "PLUTINUM"
        
//        let chile_1 = platinumVC(itemInfo: "second")
//            let child_2 = MVPVC(itemInfo: "first")
//
        
          return [mvpVC , platinum]
      }
    
   
    
}
