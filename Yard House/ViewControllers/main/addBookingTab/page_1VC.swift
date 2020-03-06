//
//  page_1VC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/26.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
import Kingfisher

class page_1VC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet var mainView: UIView!
    var service : serviceType!
    
    @IBOutlet weak var titleBig: UILabel!
    @IBOutlet weak var titleSmall: UILabel!
    
    var rentalTags = [Tag]()
    var lessonTags = [lessonTag]()
    var currentSelectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        switch service {
        case .rental:
            self.rentalTags = sharedData.initialData.rental.tags
            self.containerViewHeight.constant = CGFloat(self.rentalTags.count * 90 + 10)
            self.titleBig.text = "Booking"
            self.titleSmall.text = "Please sepcify your booking"
        case .lesson:
            self.lessonTags = sharedData.initialData.lesson.tags
            self.containerViewHeight.constant = CGFloat(self.lessonTags.count * 90 + 10)
            self.titleBig.text = "Lesson"
            self.titleSmall.text = "Please sepcify your lesson"
        default:
            print("nothing")
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
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_2VC") as! page_2VC
        
        switch self.service {
        case .rental:
            vc.selectedRentalTag = self.rentalTags[self.currentSelectedIndex]
            vc.service = .rental
        case .lesson:
            vc.selectedLessonTag = self.lessonTags[self.currentSelectedIndex]
            vc.service = .lesson
        default:
            print("ddd")
        }
        
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        
    }
    
}

extension page_1VC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.service == serviceType.rental {
            return rentalTags.count
        }
        return self.lessonTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "page_1Cell", for: indexPath) as! page_1Cell
        cell.selectionStyle = .none
        
        if indexPath.row == self.currentSelectedIndex {
            cell.selectImg.image = UIImage(named: "radio.png")?.tinted(with: appColors.appMainColor)
        }
        else{
            cell.selectImg.image = UIImage(named: "radioEmpty.png")?.tinted(with: appColors.appMainColor)
        }
        
        var url_str = ""
        switch self.service {
        case .rental:
            url_str = self.rentalTags[indexPath.row].icon
            cell.itemName.text = self.rentalTags[indexPath.row].name
        case . lesson:
            url_str = self.lessonTags[indexPath.row].icon
            cell.itemName.text = self.lessonTags[indexPath.row].name
        default:
            print("Ok")
        }
        
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
        
        if indexPath.row != self.currentSelectedIndex {
            let lastSelected = self.currentSelectedIndex
            self.currentSelectedIndex = indexPath.row
            self.tableView.reloadRows(at: [IndexPath(row: lastSelected, section: 0)], with: .right)
            self.tableView.reloadRows(at: [IndexPath(row: self.currentSelectedIndex, section: 0)], with: .left)
        }
    }
    
}



