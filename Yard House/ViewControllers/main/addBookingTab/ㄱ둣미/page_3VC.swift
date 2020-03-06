//
//  page_3VC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/26.
//  Copyright © 2019 OnOuchs. All rights reserved.
//
import Kingfisher
import UIKit

class page_3VC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var pagePosition: UILabel!
    
    var service : serviceType!
    
    var selectedRentalTag : Tag?
    var selectedLessonTag : lessonTag!
    
    var selectedRentalItem : RentalItem?
    var selectedLessonItem : LessonItem!
    
    var rentalTimes : [Option]!
    var lessonTimes : [TimePrice]!
    
    var currentSelectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        switch self.service {
        case .rental:
            self.rentalTimes = self.selectedRentalItem!.timeOptions
            self.containerViewHeight.constant = CGFloat(self.rentalTimes.count * 50 + 40)
        case .lesson :
            self.lessonTimes = self.selectedLessonItem.timePrice
            self.containerViewHeight.constant = CGFloat(self.lessonTimes.count * 50 + 40)
        case .hittrax:
            self.rentalTimes = self.selectedRentalItem!.timeOptions
            self.containerViewHeight.constant = CGFloat(self.rentalTimes.count * 50 + 40)
            self.pagePosition.text = "1 of 3"
            
        default:
            print("fff")
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        
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
    @IBAction func nextAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_4VC") as! page_4VC
        
        vc.selectedRentalItem = self.selectedRentalItem
        let timeOption = self.selectedRentalItem!.timeOptions[self.currentSelectedIndex]
        vc.timeOption = timeOption
        vc.timeArrayIndex = self.currentSelectedIndex
        vc.service = self.service
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        
    }
    
}

extension page_3VC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.service {
        case .rental:
            return self.rentalTimes.count
        case .lesson:
            return self.lessonTimes.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "page_3Cell", for: indexPath) as! page_3Cell
        cell.selectionStyle = .none
        
        
        
        if indexPath.row == self.currentSelectedIndex {
            cell.selectImage.image = UIImage(named: "radio.png")?.tinted(with: appColors.appMainColor)
        }
        else{
            cell.selectImage.image = UIImage(named: "radioEmpty.png")?.tinted(with: appColors.appMainColor)
        }
        
        switch self.service {
        case .rental:
            let option = self.rentalTimes[indexPath.row]
            cell.timeLabel.text = String(option.max) + " min " + option.label
        case .lesson:
            let option = self.lessonTimes[indexPath.row]
            cell.timeLabel.text = String(option.max) + " min, " + "$ " + publicFunctions().getTwodigitString(dbl: option.price)
        default:
            print("fff")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != self.currentSelectedIndex {
            let lastSelected = self.currentSelectedIndex
            self.currentSelectedIndex = indexPath.row
            self.tableView.reloadRows(at: [IndexPath(row: lastSelected, section: 0)], with: .right)
            self.tableView.reloadRows(at: [IndexPath(row: self.currentSelectedIndex, section: 0)], with: .left)
        }
    }
    
}



