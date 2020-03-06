//
//  platinumVC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/16/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class platinumVC: UIViewController , IndicatorInfoProvider{
    
    var itemInfo: IndicatorInfo = "platinum"
    
    @IBOutlet weak var collectionView: UICollectionView!
    var mvps = sharedData.initialData.membership.platinums

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension platinumVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mvps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "membershipCell", for: indexPath) as! membershipCell
        let mvp = self.mvps[indexPath.row]
        
        publicFunctions().addShadow(view: cell.backView, cornerRadius: 3, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.8)
        
        cell.name.text = mvp.name
        let interval = (mvp.interval == 1) ? 0 : mvp.interval
        if mvp.interval == 1 {
            cell.price.text = (mvp.subscriptionType != "subscription") ? ("Price: $\(publicFunctions().getTwodigitString(dbl: Double(mvp.price)))") : ("Price: $\(publicFunctions().getTwodigitString(dbl: Double(mvp.price))) / month")
        }
        else{
            cell.price.text = (mvp.subscriptionType != "subscription") ? ("Price: $\(publicFunctions().getTwodigitString(dbl: Double(mvp.price)))") : ("Price: $\(publicFunctions().getTwodigitString(dbl: Double(mvp.price))) / \(interval) months")
        }
        cell.bookBtn.tag = indexPath.row
        cell.bookBtn.addTarget(self, action: #selector(bookBtnClicked(_:)), for: .touchUpInside)
        
        return cell
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("selected")
    }
    
    @objc func bookBtnClicked (_ sender : UIButton) {
        
        
        let index = sender.tag
        
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_paymentVC") as! page_paymentVC
        
        vc.membershipId = self.mvps[index].id
        vc.service = .membership
        vc.totalamountInt = Double(self.mvps[index].price)
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        
        
    }
    
}
extension platinumVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 230, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
