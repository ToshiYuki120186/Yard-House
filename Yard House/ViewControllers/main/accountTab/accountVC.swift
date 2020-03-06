//
//  accountVC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/25.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView
import Stripe

class accountVC: UIViewController ,MICountryPickerDelegate , UITextFieldDelegate , NVActivityIndicatorViewable{
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var defaultCardView: UIView!
    @IBOutlet weak var savedCardsView: UIView!
    
    
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryPickBtn: UIButton!
    @IBOutlet var mainBackground: UIView!
    
    @IBOutlet weak var paymentsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var savedCardHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var defaultCardBrand: UILabel!
    @IBOutlet weak var defaultCardDescription: UILabel!
    
    @IBOutlet weak var cardField: STPPaymentCardTextField!
    
    
    var defaultCardIndex = 0
    
    
    var countryFlag_Img = UIImage()
    var iso_Code = String()
    var cellHeight : CGFloat = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.mainBackground.backgroundColor = appColors.appBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initVC()
    }
    
    func initVC () {
        
        publicFunctions().addShadow(view: self.accountView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
        publicFunctions().addShadow(view: self.paymentView, cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 5, height: 5), shadowOpacity: 0.8)
   
        
        //publicFunctions().addShadow(view: self.accountBtn, cornerRadius: 5, shadowColor: appColors.appMainColor, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.8)
        //self.accountBtn.setTitleColor(UIColor.white, for: .normal)
        //self.accountBtn.backgroundColor = appColors.appMainColor
        
        let bundle = "assets.bundle/"
        
        if var countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
               print("countryCode",countryCode)
               countryCode = "CA"
               let get_Flag = UIImage(named: bundle + countryCode.uppercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
               let dialingCodeList = Themes.sharedInstance.getCountryList()
               let currentCode = dialingCodeList.value(forKey: countryCode.uppercased()) as? [String] ?? ["",""]
               countryImage.image = get_Flag
               codeLabel.text = "+" + currentCode[1]

           }
        
           self.countryPickBtn.addTarget(self, action: #selector(countryPickerAction), for: .touchUpInside)
        
        self.name.text = sharedData.userData.name
        self.name.delegate = self
        self.email.text = sharedData.userData.email
        self.email.delegate = self
        self.phone.text = sharedData.userData.phoneNumber
        self.phone.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
        
        //self.accountSaveBtnTapped(self.accountBtn)
        self.accountBtn.addTarget(self, action: #selector(accountSaveBtnTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        self.defaultCardView.layer.cornerRadius = 3
        self.defaultCardView.layer.borderWidth = 1
        self.defaultCardView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.layoutScrollView()
        
        //MARK: find default card
        if sharedData.userData.stripeCards.count != 0 {
            if sharedData.userData.defaultCardID != "" {
                for i in 0 ..< sharedData.userData.stripeCards.count {
                    let card = sharedData.userData.stripeCards[i]
                    if card.id == sharedData.userData.defaultCardID {
                        self.defaultCardBrand.text = card.brand
                        self.defaultCardDescription.text = "Ending in \(card.last4) (expires on \(card.expMonth)/\(card.expYear))"
                        self.defaultCardIndex = i
                        break
                    }
                }
            }
            else{
                let card = sharedData.userData.stripeCards.first!
                self.defaultCardBrand.text = card.brand
                self.defaultCardDescription.text = "Ending in \(card.last4) (expires on \(card.expMonth)/\(card.expYear))"
                self.defaultCardIndex = 0
            }
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConst.constant = keyboardHeight - 50.0

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.bottomConst.constant = 0
    }
    
    func layoutScrollView () {
        
        let topFixed : CGFloat = 10 + 460 + 30 + 50
        if sharedData.userData.stripeCards.count == 0 {
            
            self.savedCardsView.isHidden = true
            let height : CGFloat = 0
            self.savedCardHeight.constant = height
            self.paymentsViewHeight.constant = height + 120 + 50
            self.tableviewHeight.constant = 0
            self.scrollHeight.constant = height + 120  + 50 + topFixed + 30
        }
        else{
            sharedData.userData.stripeCards.count
            self.savedCardsView.isHidden = false
            self.tableviewHeight.constant = self.cellHeight * CGFloat(sharedData.userData.stripeCards.count)
            let height : CGFloat = self.cellHeight * CGFloat(sharedData.userData.stripeCards.count) + 40 + 40 + 50 + 20 + 40 + 15
            self.savedCardHeight.constant = height
            self.paymentsViewHeight.constant = height + 120 + 50
            
            self.scrollHeight.constant = height + 120 + 50 +  topFixed + 30
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    @objc func accountSaveBtnTapped ( _ sender : UIButton ) {
        
        if self.accountBtn.titleLabel?.text == "Edit" {
            self.name.textColor = .darkGray
            self.name.isUserInteractionEnabled = true
            self.email.textColor = .darkGray
            self.email.isUserInteractionEnabled = true
            self.password.textColor = .darkGray
            self.password.isUserInteractionEnabled = true
            self.confirmPassword.textColor = .darkGray
            self.confirmPassword.isUserInteractionEnabled = true
            self.phone.textColor = .darkGray
            self.phone.isUserInteractionEnabled = true
            self.countryPickBtn.isUserInteractionEnabled = true
            self.codeLabel.textColor = .darkGray
            self.accountBtn.setTitle("Save", for: .normal)
        }
        else{
            self.name.textColor = .lightGray
            self.name.isUserInteractionEnabled = false
            self.email.textColor = .lightGray
            self.email.isUserInteractionEnabled = false
            self.password.textColor = .lightGray
            self.password.isUserInteractionEnabled = false
            self.confirmPassword.textColor = .lightGray
            self.confirmPassword.isUserInteractionEnabled = false
            self.phone.textColor = .lightGray
            self.phone.isUserInteractionEnabled = false
            self.countryPickBtn.isUserInteractionEnabled = false
            self.codeLabel.textColor = .lightGray
            self.accountSaveAction()
            self.accountBtn.setTitle("Edit", for: .normal)
        }
    }
    
    func accountSaveAction () {
        
        if self.name.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please fill name", position: .top, level: .normal)
            return
        }
        
        if !publicFunctions().isValidEmailAddress(emailAddressString: self.email.text!) {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Email is invalid", position: .top, level: .normal)
            return
        }
        
        if phone.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Phone number is invalid", position: .top, level: .normal)
            return
        }
        
        
        if self.password.text == "" || self.confirmPassword.text == "" {
            self.uploadAccountSettings(name: self.name.text!, email: self.email.text!, phone_number: self.phone.text!, password: "")
        }
        else{
            if self.password.text == self.confirmPassword.text {
                self.uploadAccountSettings(name: self.name.text!, email: self.email.text!, phone_number: self.phone.text!, password: self.password.text!)
            }
            else{
                Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Confirm assword does not match", position: .top, level: .normal)
                return
            }
        }
        
        
    }
    
    func uploadAccountSettings ( name : String , email : String , phone_number : String , password : String ) {
        if Connectivity.isConnectedToInternet {
              
              
            let parameters = ["name" : name,
                              "email" : email ,
                              "phone_number" : phone_number,
                              "password" : password]
              let url_str = apiNames.updateAccount
              self.startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
              webClient().saveDefaultCard(parameters: parameters, token: sharedData.userData.token, url: url_str , completionHandler: { (error, result) in
                  
                  DispatchQueue.main.async {
                      self.stopAnimating(nil)
                  }
                  if error != nil {
                      Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Something went wrong", position: .top, level: .normal)
                      return
                  } else {
                    if result != nil {
                          
                          DispatchQueue.main.async {
                              Themes.sharedInstance.showAlert(form: .tabView, theme: .success, title: "Success", body: "You have successfully updated your account information.", position: .top, level: .normal)
                            
                            sharedData.userData.email = email
                            sharedData.userData.name = name
                            sharedData.userData.phoneNumber = phone_number
                            UserDefaults.standard.set(password, forKey: "password")
                            UserDefaults.standard.set(email, forKey: "email")
                            
                            self.initVC()
                              
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
    
    
    @IBAction func defaultCardSelectAction(_ sender: UIButton) {
        
        let view: selectDefaultCard = try! SwiftMessages.viewFromNib()
                view.configureDropShadow()
                view.selectRow = { rowIndex in
                    print(" row = ", rowIndex)
                    SwiftMessages.hide()
                }
                
                var config = SwiftMessages.defaultConfig
                config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                config.duration = .forever
                config.presentationStyle = .center
                config.dimMode = .gray(interactive: true)
                SwiftMessages.show(config: config, view: view)
    }
    
    
    @objc func countryPickerAction(){
        let picker = MICountryPicker { (name, code) -> () in
            print("The code Is",code)
        }

        picker.customCountriesCode = Themes.sharedInstance.codeName_Only
        picker.delegate = self
        picker.didSelectCountryClosure = { name, code in

        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(picker, animated: true)
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String,countryFlagImage:UIImage) {
        
        picker.searchController.searchBar.endEditing(true)
        
        codeLabel.text = dialCode
        countryImage.image = countryFlagImage
        
        countryFlag_Img = countryFlagImage
        iso_Code = code
        
        self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "token")
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        let stry = UIStoryboard(name: "auth", bundle: nil)
        rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "auth")
        
    }
    
    @IBAction func saveDefaultCardAction(_ sender: UIButton) {
        
        if Connectivity.isConnectedToInternet {
            
            let card_id = sharedData.userData.stripeCards[self.defaultCardIndex].id
            let url_str = apiNames.saveDefaultCard
      
            self.startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().saveDefaultCard(parameters: ["default_card_id" : card_id ], token: sharedData.userData.token, url: url_str , completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Something went wrong", position: .top, level: .normal)
                    return
                } else {
                    if let newKey = result {
                        
                        DispatchQueue.main.async {
                            Themes.sharedInstance.showAlert(form: .tabView, theme: .success, title: "Success", body: "You have successfully set your default card.", position: .top, level: .normal)
                            sharedData.userData.stripeCustomerID = newKey
                            
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
    
    @IBAction func saveCardAction(_ sender: Any) {
        
        if self.cardField.cardNumber == nil || self.cardField.cardNumber == "" || self.cardField.expirationYear == 0 || self.cardField.expirationMonth == 0 || self.cardField.cvc == nil || self.cardField.cvc == "" {
            
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input all fields", position: .top, level: .alert)
            return
        }
        else{
            
            let cardParams = STPCardParams()
            cardParams.number = self.cardField.cardNumber!
            cardParams.expMonth = self.cardField.expirationMonth
            cardParams.expYear = self.cardField.expirationYear
            cardParams.cvc = self.cardField.cvc!
            cardParams.address.postalCode = self.cardField.postalCode
            
            STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
                  guard let token = token, error == nil else {
                    
              
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Invalid card", position: .top, level: .alert)
                    
                      return
                  }
                self.saveCardWithToken(tokenId: token.tokenId)
            }
        }
        
        
        
        
        
    }
    
    func saveCardWithToken (tokenId : String ) {
        
        if Connectivity.isConnectedToInternet {
                    
                    let url_str = apiNames.saveCard
                    
                    self.startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
                    webClient().saveDefaultCard(parameters: ["token" : tokenId ], token: sharedData.userData.token, url: url_str , completionHandler: { (error, result) in
                        
                        DispatchQueue.main.async {
                            self.stopAnimating(nil)
                        }
                        if error != nil {
                            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Something went wrong", position: .top, level: .normal)
                            return
                        } else {
                            if let newKey = result {
                                
                                DispatchQueue.main.async {
                                    
                                    Themes.sharedInstance.showAlert(form: .tabView, theme: .success, title: "Success", body: "You have successfully saved your card.", position: .top, level: .normal)
                                    sharedData.userData.stripeCustomerID = newKey
                                    for i in 0 ..< 20 {
                                        self.cardField.deleteBackward()
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
    
}

extension accountVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedData.userData.stripeCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "savedCardCell", for: indexPath) as! savedCardCell
        cell.selectionStyle = .none
        let card = sharedData.userData.stripeCards[indexPath.row]
        
        cell.cellBack.layer.cornerRadius = 3
        cell.cellBack.layer.borderColor = UIColor.lightGray.cgColor
        cell.cellBack.layer.borderWidth = 1
        
        cell.brand.text = card.brand
        
        cell.desc.text = "Ending in \(card.last4) (expires on \(card.expMonth)/\(card.expYear))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    
    
    
    
    
    
}
