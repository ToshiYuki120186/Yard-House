//
//  page_2VC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/26.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit

class page_2VC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    
    var currentSelectedIndex = 0
    var rentalItems = [RentalItem]()
    var lessonItems = [LessonItem]()
    var service : serviceType!
    var selectedRentalTag : Tag!
    var selectedLessonTag : lessonTag!
    
    @IBOutlet weak var titleBig: UILabel!
    @IBOutlet weak var titleSmall: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch service {
        case .rental:
            self.titleBig.text = "Rental Type"
            self.titleSmall.text = "Please specify your rental"
            for i in sharedData.initialData.rental.items {
                if i.rentalTags.contains(String(self.selectedRentalTag.id)){
                    self.rentalItems.append(i)
                }
            }
        case .lesson:
            self.titleBig.text = "Lesson Type"
            self.titleSmall.text = "Please specify your lesson"
            for i in sharedData.initialData.lesson.items {
                if i.tags.contains(String(self.selectedLessonTag.id)){
                    self.lessonItems.append(i)
                }
            }
        default:
            print("nothing")
        }
        
        
        

        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        self.mainView.backgroundColor = appColors.appBackgroundColor
            
        publicFunctions().addShadow(view: self.BtnBack, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnBack.setTitleColor(appColors.appMainColor, for: .normal)
      
        
        publicFunctions().addShadow(view: self.BtnNext, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnNext.setTitleColor(UIColor.white, for: .normal)
        self.BtnNext.backgroundColor = appColors.appMainColor
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = UIColor.white

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                print(newsize)
                self.scrollHeight.constant = newsize.height + 2.0
            }
        }
    }
        
        
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.AnimationFadePop(animated: true, transitionType: .reveal, subType: .fromLeft, timingFunction: .easeInEaseOut)
        
    }
    @IBAction func nextAction(_ sender: Any) {
        
       let storyBoard = UIStoryboard(name: "main", bundle: nil)
       
        
        switch self.service {
        case .rental:
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_3VC") as! page_3VC
            vc.service = .rental
            vc.selectedRentalTag = self.selectedRentalTag
            vc.selectedRentalItem = self.rentalItems[self.currentSelectedIndex]
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        case .lesson:
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_3VCLessonViewController") as! page_3VCLessonViewController
            vc.service = .lesson
            vc.selectedLessonTag = self.selectedLessonTag
            vc.selectedLessonItem = self.lessonItems[self.currentSelectedIndex]
            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
            
        default:
            print("ddd")
        }
        
       
    }


}

extension page_2VC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.service == serviceType.rental {
            return rentalItems.count
        }
        else if self.service == serviceType.lesson{
            return lessonItems.count
        }
        return self.rentalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "page_2Cell", for: indexPath) as! page_2Cell
        
        cell.selectionStyle = .none
        
        if indexPath.row == self.currentSelectedIndex {
            cell.selectImage.image = UIImage(named: "radio.png")?.tinted(with: appColors.appMainColor)
        }
        else{
            cell.selectImage.image = UIImage(named: "radioEmpty.png")?.tinted(with: appColors.appMainColor)
        }
        
        cell.numberImage.image = UIImage(named: "numberDecor.png")?.tinted(with: appColors.appMainColor)
        cell.numberLabel.text = String(indexPath.row + 1)
        
        switch self.service {
        case .rental:
            cell.nameLabel.text = self.rentalItems[indexPath.row].name
            cell.descriptionLabel.text = self.rentalItems[indexPath.row].itemDescription
        case .lesson:
            cell.nameLabel.text = self.lessonItems[indexPath.row].name
            cell.descriptionLabel.text = self.lessonItems[indexPath.row].itemDescription
        default:
            print("ddd")
        }
        
        
        
        return cell
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.currentSelectedIndex {
            let lastSelected = self.currentSelectedIndex
            self.currentSelectedIndex = indexPath.row
            self.tableView.reloadRows(at: [IndexPath(row: lastSelected, section: 0)], with: .right)
            self.tableView.reloadRows(at: [IndexPath(row: self.currentSelectedIndex, section: 0)], with: .left)
        }
    }
    
    
    
    
    
    
}
