//
//  homeVC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/25.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
var screenWidth = UIScreen.main.bounds.width

class homeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainer: UIView!
    
    @IBOutlet var mainBackground: UIView!
    let icons = ["ic_baseball" , "ic_racket" , "ic_camps" , "ic_caps" , "hittrax" , "ic_deals"]
    let labels = ["Book" , "Lessons" , "Camps" , "Membership" , "Hittrax" , "Deals"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainBackground.backgroundColor = appColors.appBackgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        publicFunctions().addShadow(view: self.collectionViewContainer, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
    }
}

extension homeVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "mainHomeCollectionCell", for: indexPath) as! mainHomeCollectionCell
        
       
        cell.cellBackground.layer.cornerRadius = 10
        cell.cellBackground.layer.borderColor = appColors.appLabelColor.withAlphaComponent(0.3).cgColor
        cell.cellBackground.layer.borderWidth = 2
        cell.cellBackground.layer.masksToBounds = true
        
        cell.cellImage.image = UIImage(named: self.icons[indexPath.row])?.tinted(with: appColors.appMainColor)
        cell.cellLabel.text = self.labels[indexPath.row]
        cell.cellLabel.textColor = appColors.appLabelColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        
        switch indexPath.row {
        case 0:
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_1VC") as! page_1VC
            vc.service = .rental
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        case 1:
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_1VC") as! page_1VC
            vc.service = .lesson
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        case 2:
            let vc = storyBoard.instantiateViewController(withIdentifier: "campVC") as! campVC
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        case 3:
            let vc = storyBoard.instantiateViewController(withIdentifier: "membershipVC") as! membershipVC
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        case 4:
            
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_3VC") as! page_3VC
            vc.service = .hittrax
            vc.selectedRentalTag = nil
            
            var item : RentalItem!
            for ritem in sharedData.initialData.rental.items {
                if ritem.id == 2 {
                    item = ritem
                    break
                }
            }
            
            vc.selectedRentalItem = item
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
            
        default:
            print("fff")
        }
    }
    
    
    
    
    
}

extension homeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = ( screenWidth - 60 - 40 ) / 2.0
        let itemHeight = CGFloat((470 - 80) / 3.0)
        
        return CGSize(width: itemWidth, height: itemHeight)
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
}
