//
//  page_2VC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/26.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView

class page_paymentVC: UIViewController , NVActivityIndicatorViewable , UITextViewDelegate{
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var paymentBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var savedCardView: UIView!
    @IBOutlet weak var savedCardHeight: NSLayoutConstraint!
    
    
    var selectedRentalItem : RentalItem!
    var timeOption : Option!
    var timeArrayIndex : Int!
    var playerNumber : Int!
    var book_time : String!
    var service : serviceType!
    
    var lessonTimePrice : TimePrice!
    var lessonItemId : Int!
    var coachId : Int!
    
    var campId : Int!
    var membershipId : Int!
    
    @IBOutlet weak var addcardBtn: UIButton!
    @IBOutlet weak var total_amount: UILabel!
    @IBOutlet weak var scrollheight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentText: UITextView!
    
    var totalamountInt : Double!
    var cellHeight : CGFloat = 55
    var defaultCardIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.paymentBtn.isHidden = true
        
        
        
        
        if sharedData.userData.stripeCards.count == 0{
            //self.NocardView.isHidden = false
            self.paymentBtn.isHidden = true
        }
        else{
            //self.NocardView.isHidden = true
            self.paymentBtn.isHidden = false
        }
        
        self.commentView.layer.cornerRadius = 3
        self.commentView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentView.layer.borderWidth = 1
        self.commentText.delegate = self
        
        self.scrollheight.constant = CGFloat(sharedData.userData.stripeCards.count) * self.cellHeight + 450

        publicFunctions().addShadow(view: self.containerView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        self.mainView.backgroundColor = appColors.appBackgroundColor
            
     
        publicFunctions().addShadow(view: self.paymentBtn, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
        self.paymentBtn.setTitleColor(UIColor.white, for: .normal)
        self.paymentBtn.backgroundColor = appColors.appMainColor
        
//        self.addcardBtn.layer.borderWidth = 1
//        self.addcardBtn.layer.borderColor = UIColor.darkGray.cgColor
        
//        publicFunctions().addShadow(view: self.addcardBtn, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
//
       
        self.totalamountInt = self.calculateAmount()
        self.total_amount.text = "$ " + publicFunctions().getTwodigitString(dbl: Double(self.totalamountInt))
        
        if sharedData.userData.stripeCards.count == 0 {
            self.savedCardView.isHidden = true
            self.savedCardHeight.constant = 0
        }
        else{
            self.savedCardView.isHidden = false
            self.savedCardHeight.constant = CGFloat( sharedData.userData.stripeCards.count ) * self.cellHeight + 10
            for i in 0 ..< sharedData.userData.stripeCards.count {
                if sharedData.userData.stripeCards[i].id == sharedData.userData.defaultCardID {
                    self.defaultCardIndex = i
                }
            }
            
            if sharedData.userData.stripeCards.count > 4 {
                self.savedCardHeight.constant = CGFloat( 3 ) * self.cellHeight + 10
            }
            
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstant.constant = keyboardHeight - 50.0

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.bottomConstant.constant = 0
    }
    
    @IBAction func paymentBtnTapped(_ sender: Any) {
        
        self.pay_check(tokenId: "", saveCard: 0, card_id: sharedData.userData.stripeCards[self.defaultCardIndex].id, SCard: nil, comment: self.commentText.text!)
        
        
    }
    
    func calculateAmount()->Double{
        switch self.service {
        case .rental:
            let temp = self.selectedRentalItem.priceOptions[self.playerNumber]
            return Double(temp[timeArrayIndex].price)
        case .lesson:
            let price = self.lessonTimePrice.price
            return price
        case .camp:
            return self.totalamountInt
        case .membership:
            return self.totalamountInt
        default:
            return 0
        }
        
        
    }
    
    @IBAction func addCardBtnTapped(_ sender: Any) {
        
        let view: addCardView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.amount = self.totalamountInt
        
        view.MakePayment = { token , is_save , card , comment in
            SwiftMessages.hide()
            let save = is_save ? 1 : 0
            DispatchQueue.main.async {
                self.pay_check(tokenId: token, saveCard: save, card_id: "new_card", SCard: card, comment: comment)
            }
        }
        
        view.cancel = {
            SwiftMessages.hide()
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .top
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
        
        
    }
    
    func pay_check(tokenId : String , saveCard : Int , card_id : String , SCard : StripeCard? , comment : String ) {
        
        if Connectivity.isConnectedToInternet {
            
            var parameters = [String : Any]()
            var url_str = ""
            switch self.service {
            case .rental:
                parameters = [ "item_id": self.selectedRentalItem.id,
                "duration": self.timeOption.max,
                "player_number" : self.playerNumber!,
                "book_time" : self.book_time! ,
                "card_id" : card_id,
                "save_card" : saveCard,
                "token" : tokenId ,
                "amount" : self.totalamountInt! ,
                "comment" : comment] as [String : Any]
                url_str = apiNames.rentalCheckout
            case .lesson:
                parameters =  [ "item_id": self.lessonItemId!,
                                "duration": self.lessonTimePrice.max,
                               "book_time" : self.book_time! ,
                               "card_id" : card_id,
                               "save_card" : saveCard,
                               "token" : tokenId ,
                               "amount" : self.totalamountInt! ,
                               "comment" : "" ,
                               "coach_id":self.coachId!] as [String : Any]
                url_str = apiNames.lessonCheckout
            case .camp:
                parameters =  [ "item_id": self.campId!,
                               "card_id" : card_id,
                               "save_card" : saveCard,
                               "token" : tokenId ,
                               "comment" : "" ] as [String : Any]
                url_str = apiNames.campCheckout
            case .membership:
                parameters =  [ "item_id": self.membershipId!,
                               "card_id" : card_id,
                               "save_card" : saveCard,
                               "token" : tokenId ,
                               "comment" : "" ] as [String : Any]
                url_str = apiNames.membershipCheckout

            default:
                print("ddd")
            }
            
        
            
            
            self.startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().payCheck(parameters: parameters, token: sharedData.userData.token, url: url_str , completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Something went wrong", position: .top, level: .normal)
                    return
                } else {
                    if let newKey = result {
                        
                        DispatchQueue.main.async {
                            if SCard != nil {
                                sharedData.userData.stripeCards.append(SCard!)
                                sharedData.userData.stripeCustomerID = newKey
                            }
                            
                            
                            Themes.sharedInstance.showAlert(form: .tabView, theme: .success, title: "Success", body: "You have successfully paid.", position: .top, level: .normal)
                            
                            
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
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
}

extension page_paymentVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedData.userData.stripeCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "savedCardCell", for: indexPath) as! savedCardCell
        let card = sharedData.userData.stripeCards[indexPath.row]
        
        cell.cellBack.backgroundColor = .white
        cell.brand.textColor = .darkGray
        cell.desc.textColor = .darkGray
        if indexPath.row == self.defaultCardIndex {
            cell.checkImg.image = UIImage(named: "radio")?.tinted(with: UIColor.darkGray)
        }
        else{
            cell.checkImg.image = UIImage(named: "radioEmpty")?.tinted(with: UIColor.darkGray)
        }
        cell.brand.text = card.brand
        
        cell.desc.text = "Ending in \(card.last4) (expires on \(card.expMonth)/\(card.expYear))"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != self.defaultCardIndex {
            let lastSelected = self.defaultCardIndex
            self.defaultCardIndex = indexPath.row
            self.tableView.reloadRows(at: [IndexPath(row: lastSelected, section: 0)], with: .left)
            self.tableView.reloadRows(at: [IndexPath(row: self.defaultCardIndex , section: 0)], with: .right)
        }
        
    }
    
    
    
    
    
    
    
    
    
}
