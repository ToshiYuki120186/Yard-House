//
//  page_3VCLessonViewController.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/6/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import Kingfisher
import UIKit
import FSCalendar
import NVActivityIndicatorView

class page_3VCLessonViewController : UIViewController , NVActivityIndicatorViewable{

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendarMainView: UIView!
    @IBOutlet weak var yearText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coachView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTime: UICollectionView!
    
    
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    @IBOutlet weak var timesView: UIView!
    @IBOutlet weak var timeViewHeight: NSLayoutConstraint!
    
    var currentSelectedDate = Date()
    
    var service : serviceType!
    var selectedLessonTag : lessonTag!
    var selectedLessonItem : LessonItem!
    var lessonTimes : [TimePrice]!
    var availableCoaches = [Coach]()
    
    
    var timeArray = [String]()
    
    var currentSelectedIndex = 0
    var currentSelectedIndex_collection = 0
    var currentSelectedIndex_collection_time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lessonTimes = self.selectedLessonItem.timePrice
        self.containerViewHeight.constant = CGFloat(self.lessonTimes.count * 50 + 40)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionViewTime.delegate = self
        self.collectionViewTime.dataSource = self
        
        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        publicFunctions().addShadow(view: self.calendarView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        publicFunctions().addShadow(view: self.timesView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        publicFunctions().addShadow(view: self.coachView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        
        self.mainView.backgroundColor = appColors.appBackgroundColor
        
        publicFunctions().addShadow(view: self.BtnBack, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnBack.setTitleColor(appColors.appMainColor, for: .normal)
      
        
        publicFunctions().addShadow(view: self.BtnNext, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnNext.setTitleColor(UIColor.white, for: .normal)
        self.BtnNext.backgroundColor = appColors.appMainColor
        
        self.calendarMainView.layer.cornerRadius = 5
        self.calendarMainView.layer.masksToBounds = true
        self.calendar.delegate = self
        self.calendar.dataSource = self
    
        self.yearText.text = publicFunctions().getDateString(date: Date(), timeZone: "PST", dateformatter: "yyyy")
        self.dayText.text = publicFunctions().getDateString(date: Date(), timeZone: "PST", dateformatter: "EEE, MMM dd")
        
        self.getAvailableCoaches()
    }
    
    func getScrollHeight() -> CGFloat {
        
        if self.timeArray.count % 3 == 0 {
            let itemRowCount = ( self.timeArray.count == 0 ) ? 0 : ( self.timeArray.count / 3 )
            
            let itemHeight = ( self.timeArray.count == 0 ) ? 0 :  ( itemRowCount * 60 + 20 )
           // self.timeViewHeight.constant = CGFloat(itemHeight)
            return CGFloat(930) + CGFloat(itemHeight)
        }
        else{
            let itemRowCount = ( self.timeArray.count / 3 + 1 )
            
            let itemHeight = ( itemRowCount * 60 + 20 )
        //    self.timeViewHeight.constant = CGFloat(itemHeight)
            return CGFloat(930) + CGFloat(itemHeight)
        }
        
    }
    
    func getAvailableCoaches (){
            
        if Connectivity.isConnectedToInternet {
        
            let decoded = try! JSONSerialization.jsonObject(with: self.selectedLessonTag.coachesData, options: [])
            let dictFromJSON = decoded as? [[String : Any]] ?? []
            let select_d = publicFunctions().getDateString(date: self.currentSelectedDate, timeZone: "PST", dateformatter: "yyyy-MM-dd")
            var parameters = [ "duration": self.lessonTimes[self.currentSelectedIndex].max,
                               "book_date": select_d,
                               "item_id" : self.selectedLessonItem.id,
                               "coaches" : dictFromJSON ] as [String : Any]
            startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().getAvailableLessonCoaches(parameters: parameters, token: sharedData.userData.token , completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Service is not available now", position: .top, level: .normal)
                    return
                } else {
                    
                    if let array = result {
                        
                        DispatchQueue.main.async {
                            
                            if array.count != 0 {
                                self.availableCoaches = publicFunctions().returnCoachesArray(result_t: array)
                                self.collectionView.reloadData()
                                parameters.removeValue(forKey: "coaches")
                                parameters["coach_id"] = self.availableCoaches.first!.id
                                self.getAvailableTime(parameters: parameters)
                            }
                            else{
                                self.scrollHeight.constant = 930
                            }
                            
                        }
                        
                    }
                    
                }
            }
            )
        }
        else{
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Network connection error.", position: .top, level: .alert)
            return
        }
    }
    
    func getAvailableTime(parameters : [String : Any]){
            
        if Connectivity.isConnectedToInternet {
            
            startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().getLessonAvailableTime(parameters: parameters, token: sharedData.userData.token , completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Service is not available now", position: .top, level: .normal)
                    return
                } else {
                    
                    if let array = result {
                        
                        DispatchQueue.main.async {
                            self.timeArray = array
                            
                            self.scrollHeight.constant = self.getScrollHeight()
                            self.timeViewHeight.constant = self.getScrollHeight() - 930 - 40
                            self.collectionViewTime.reloadData()
                            
                            if self.timeArray.isEmpty {
                                self.currentSelectedIndex_collection_time = -1
                            }
                            else{
                                self.currentSelectedIndex_collection_time = 0
                            }
                        }
                        
                    }
                    
                }
            }
            )
        }
        else{
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Network connection error.", position: .top, level: .alert)
            return
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.AnimationFadePop(animated: true, transitionType: .reveal, subType: .fromLeft, timingFunction: .easeInEaseOut)
        
    }
    @IBAction func nextAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "page_paymentVC") as! page_paymentVC
        
        vc.service = .lesson
        vc.lessonTimePrice = self.lessonTimes[self.currentSelectedIndex]
        vc.lessonItemId = self.selectedLessonItem.id
        vc.book_time = publicFunctions().getDateString(date: self.currentSelectedDate, timeZone: "PST", dateformatter: "yyyy-MM-dd") +  " "  + self.timeArray[self.currentSelectedIndex_collection_time]
        vc.coachId = self.availableCoaches[self.currentSelectedIndex_collection].id
        
    
        self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        
    }
    
}

extension page_3VCLessonViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lessonTimes.count
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
        
        let option = self.lessonTimes[indexPath.row]
        cell.timeLabel.text = String(option.max) + " min, " + "$ " + publicFunctions().getTwodigitString(dbl: option.price)
        
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
            
            self.getAvailableCoaches()
        }
    }
    
}

extension page_3VCLessonViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{

            return self.availableCoaches.count

        }
        return self.timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "lesson_coach_cell", for: indexPath) as! lesson_coach_cell
            
            publicFunctions().addShadow(view: cell.backView, cornerRadius: 5, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 3, height: 3), shadowOpacity: 0.8)
            
            if self.currentSelectedIndex_collection == indexPath.row {
                cell.backView.backgroundColor = appColors.appMainColor
                cell.name.textColor = UIColor.white
                cell.email.textColor = UIColor.white
                cell.phone.textColor = UIColor.white
                cell.profileImg.tintColor = UIColor.white
            }
            else{
                cell.backView.backgroundColor = UIColor.white
                cell.name.textColor = UIColor.darkGray
                cell.email.textColor = UIColor.darkGray
                cell.phone.textColor = UIColor.darkGray
                cell.profileImg.tintColor = UIColor.darkGray
            }
            
            let coach = self.availableCoaches[indexPath.row]
            cell.name.text = coach.name
            cell.email.text = coach.email
            cell.phone.text = coach.phone
            
            return cell
        }
        else{
            let cell = self.collectionViewTime.dequeueReusableCell(withReuseIdentifier: "page_5Cell", for: indexPath) as! page_5Cell
            
            cell.timeLabel.text = self.timeArray[indexPath.row]
            publicFunctions().addShadow(view: cell.containerView, cornerRadius: 3, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.8)
            cell.containerView.layer.borderColor = appColors.appMainColor.cgColor
            cell.containerView.layer.borderWidth = 1
            if self.currentSelectedIndex_collection_time == indexPath.row {
                cell.timeLabel.textColor = UIColor.white
                cell.containerView.backgroundColor = appColors.appMainColor
            }
            else{
                cell.timeLabel.textColor = appColors.appMainColor
                cell.containerView.backgroundColor = UIColor.white
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            if indexPath.row != self.currentSelectedIndex_collection {
                let lastSelected = self.currentSelectedIndex_collection
                self.currentSelectedIndex_collection = indexPath.row
                self.collectionView.reloadItems(at: [IndexPath(row: lastSelected, section: 0)])
                self.collectionView.reloadItems(at: [IndexPath(row: self.currentSelectedIndex_collection, section: 0)])
                self.getAvailableCoaches()
            }
        }
        else{
            if indexPath.row != self.currentSelectedIndex_collection_time {
                let lastSelected = self.currentSelectedIndex_collection_time
                self.currentSelectedIndex_collection_time = indexPath.row
                self.collectionViewTime.reloadItems(at: [IndexPath(row: lastSelected, section: 0)])
                self.collectionViewTime.reloadItems(at: [IndexPath(row: self.currentSelectedIndex_collection_time, section: 0)])
            }
        }
        
        
    }
    
}

extension page_3VCLessonViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            let itemWidth = ( screenWidth  - 40 - 10 ) / 2.0
            let itemHeight = CGFloat(200.0)
            print(screenWidth)
            print(itemWidth)
            
            return CGSize(width: 200, height: itemHeight)
        }
        else{
           
            let itemWidth = ( screenWidth - 40 - 10 - 40 ) / 3.0
            let itemHeight = CGFloat(40)
            
            return CGSize(width: itemWidth, height: itemHeight)
            return CGSize(width: 80, height: 80)
        }
        
        //return CGSize(width: 240, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView{
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        else{
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView{
            return 0
        }
        return 10
    }
    
    
}

extension page_3VCLessonViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // scrollView.contentOffset.x = 0
    }
    
    
}

extension page_3VCLessonViewController : FSCalendarDelegate , FSCalendarDataSource , FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        self.yearText.text = publicFunctions().getDateString(date: date, timeZone: "PST", dateformatter: "yyyy")
        self.dayText.text = publicFunctions().getDateString(date: date, timeZone: "PST", dateformatter: "EEE, MMM dd")
        self.currentSelectedDate = date
        self.getAvailableCoaches()
        
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
}

