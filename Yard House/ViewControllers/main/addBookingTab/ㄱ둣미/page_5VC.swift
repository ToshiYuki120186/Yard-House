//
//  page_5VC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/4/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//
import NVActivityIndicatorView
import UIKit
import FSCalendar
import SwiftMessages


class page_5VC: UIViewController , NVActivityIndicatorViewable{
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var BtnBack: UIButton!
    @IBOutlet weak var BtnNext: UIButton!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var yearText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var year_dateText: UIButton!
    @IBOutlet weak var pagePosition: UILabel!
    
    
    
    var selectedTag = 0
    var currentSelectedIndex = -1
    
    
    var timeArray = [String]()
    var selectedDate = publicFunctions().getDateString(date: Date(), timeZone: "PST", dateformatter: "yyyy-MM-dd")
    var currentSelectedDate = Date()
    
    var selectedRentalItem : RentalItem!
    var timeOption : Option!
    var timeArrayIndex : Int!
    var playerNumber : Int!
    var service : serviceType!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.service == serviceType.hittrax{
            self.pagePosition.text = "3 of 3"
        }
        
        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        self.mainView.backgroundColor = appColors.appBackgroundColor
            
        publicFunctions().addShadow(view: self.BtnBack, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnBack.setTitleColor(appColors.appMainColor, for: .normal)
      
        publicFunctions().addShadow(view: self.BtnNext, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.BtnNext.setTitleColor(UIColor.white, for: .normal)
        self.BtnNext.backgroundColor = appColors.appMainColor
        self.scrollHeight.constant = self.getScrollHeight()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.getAvailableTime(date: self.selectedDate)
        
        self.calendarBack.isHidden = true
        self.calendarView.layer.cornerRadius = 10
        self.calendarView.layer.masksToBounds = true
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.locale = Locale.init(identifier: "en")
        self.yearText.text = publicFunctions().getDateString(date: Date(), timeZone: "PST", dateformatter: "yyyy")
        self.dayText.text = publicFunctions().getDateString(date: Date(), timeZone: "PST", dateformatter: "EEE, MMM dd")
        
        self.calendar.select(Date())
        self.year_dateText.setTitle(self.selectedDate, for: .normal)

    }
    
    func getAvailableTime(date : String){
            
        if Connectivity.isConnectedToInternet {
        
            let parameters = [ "duration": self.timeOption.max,
                               "book_date": date,
                               "item_id" : self.selectedRentalItem.id] as [String : Any]
            startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().getRentalAvailableTime(parameters: parameters, token: sharedData.userData.token , completionHandler: { (error, result) in
                
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
                            self.collectionView.reloadData()
                            
                            if self.timeArray.isEmpty {
                                self.currentSelectedIndex = -1
                            }
                            else{
                                self.currentSelectedIndex = 0
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
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
     
        if self.currentSelectedIndex == -1 {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please select date and time.", position: .top, level: .alert)
            return
        }
        else{
            let storyBoard = UIStoryboard(name: "main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "page_paymentVC") as! page_paymentVC
            
            vc.selectedRentalItem = self.selectedRentalItem
            vc.timeOption = self.timeOption
            vc.timeArrayIndex = self.timeArrayIndex!
            vc.playerNumber = self.playerNumber!
            vc.book_time = self.selectedDate + " " +  self.timeArray[self.currentSelectedIndex]
            vc.service = .rental
            

            self.navigationController?.AnimationFadePush(controller: vc, animated: true, transitionType: .reveal, subType: .fromRight, timingFunction: .easeInEaseOut)
        }
        
       
        
    }
    
    func getScrollHeight() -> CGFloat {
        
        if self.timeArray.count % 3 == 0 {
            let itemRowCount = ( self.timeArray.count == 0 ) ? 0 : ( self.timeArray.count / 3 )
            
            let itemHeight = ( self.timeArray.count == 0 ) ? 0 :  ( itemRowCount * 60 + 20 )
            return CGFloat(85) + CGFloat(itemHeight)
        }
        else{
            let itemRowCount = ( self.timeArray.count / 3 + 1 )
            
            let itemHeight = ( itemRowCount * 60 + 20 )
            return CGFloat(85) + CGFloat(itemHeight)
        }
        
    }
    
    @IBOutlet weak var calendarBack: UIView!
    @IBAction func calendarPicker(_ sender: Any) {
        self.calendarBack.isHidden = false
    }
    
    @IBAction func calendarCancel(_ sender: Any) {
        self.calendarBack.isHidden = true
    }
    
    @IBAction func calendarOK(_ sender: Any) {
        self.calendarBack.isHidden = true
        self.selectedDate = publicFunctions().getDateString(date: self.currentSelectedDate, timeZone: "PST", dateformatter: "yyyy-MM-dd")
        self.year_dateText.setTitle(self.selectedDate, for: .normal)
        self.getAvailableTime(date: self.selectedDate)
    }
    
    
}

extension page_5VC : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "page_5Cell", for: indexPath) as! page_5Cell
        
        cell.timeLabel.text = self.timeArray[indexPath.row]
        publicFunctions().addShadow(view: cell.containerView, cornerRadius: 3, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.8)
        cell.containerView.layer.borderColor = appColors.appMainColor.cgColor
        cell.containerView.layer.borderWidth = 1
        if self.currentSelectedIndex == indexPath.row {
            cell.timeLabel.textColor = UIColor.white
            cell.containerView.backgroundColor = appColors.appMainColor
        }
        else{
            cell.timeLabel.textColor = appColors.appMainColor
            cell.containerView.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != self.currentSelectedIndex {
            let lastSelected = self.currentSelectedIndex
            self.currentSelectedIndex = indexPath.row
            self.collectionView.reloadItems(at: [IndexPath(row: lastSelected, section: 0)])
            self.collectionView.reloadItems(at: [IndexPath(row: self.currentSelectedIndex, section: 0)])
        }
        
    }
}

extension page_5VC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = ( screenWidth - 40 - 10 - 40 ) / 3.0
        let itemHeight = CGFloat(40)
        
        return CGSize(width: itemWidth, height: itemHeight)
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
        
}

extension page_5VC : FSCalendarDelegate , FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
        self.yearText.text = publicFunctions().getDateString(date: date, timeZone: "PST", dateformatter: "yyyy")
        self.dayText.text = publicFunctions().getDateString(date: date, timeZone: "PST", dateformatter: "EEE, MMM dd")
        self.currentSelectedDate = date
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}


