//
//  page_4VC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/26.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit

class page_4VC: UIViewController {

    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var pagePosition: UILabel!
    
    var stepValue = 1
    var currentSelectedIndex = 0
    
    var timeOption : Option!
    var timeArrayIndex : Int!
    var selectedRentalItem : RentalItem!
    var service : serviceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.service == serviceType.hittrax {
            self.pagePosition.text = "2 of 3"
        }
        
        
        
        minusBtn.layer.cornerRadius = 25
        minusBtn.layer.borderColor = appColors.appMainColor.cgColor
        minusBtn.layer.borderWidth = 3
        minusBtn.setTitleColor(appColors.appMainColor, for: .normal)
        minusBtn.backgroundColor = UIColor.white
        
        plusBtn.layer.cornerRadius = 25
        plusBtn.layer.borderColor = appColors.appMainColor.cgColor
        plusBtn.layer.borderWidth = 3
        plusBtn.setTitleColor(appColors.appMainColor, for: .normal)
        plusBtn.backgroundColor = UIColor.white

//        self.minusBtn.backgroundColor = appColors.appMainColor
//        self.stepLabel.backgroundColor = appColors.appMainColor
//        self.plusBtn.backgroundColor = appColors.appMainColor
      
        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        self.mainView.backgroundColor = appColors.appBackgroundColor
        
        publicFunctions().addShadow(view: self.BtnBack, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnBack.setTitleColor(appColors.appMainColor, for: .normal)
      
        
        publicFunctions().addShadow(view: self.BtnNext, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnNext.setTitleColor(UIColor.white, for: .normal)
        self.BtnNext.backgroundColor = appColors.appMainColor
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.AnimationFadePop(animated: true, transitionType: .reveal, subType: .fromLeft, timingFunction: .easeInEaseOut)
        
    }
    
    func getMaxPlayerNumber () -> Int {
        
        var numberArray = [Int]()
        for i in self.selectedRentalItem.numberOptions {
            numberArray.append(i.max)
        }
        var j = -1
        for i  in 0 ..< numberArray.count {
            if numberArray[i] >= self.stepValue {
                j = i
                return i
            }
        }
        
        if j == -1 {
            return numberArray.count - 1
        }
        
    }
    
    
    
    @IBAction func nextAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_5VC") as! page_5VC
        
        vc.selectedRentalItem = self.selectedRentalItem
        vc.timeOption = self.timeOption
        vc.timeArrayIndex = self.timeArrayIndex!
        vc.playerNumber = self.getMaxPlayerNumber()
        vc.service = self.service
        
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        self.stepValue += 1
        self.stepLabel.text = String(self.stepValue)
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        
        self.stepValue -= 1
        self.stepValue = (self.stepValue < 2) ? 1 : self.stepValue
        self.stepLabel.text = String(self.stepValue)
    }
    
}
