//
//  startUpVC.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/24.
//  Copyright © 2019 OnOuchs. All rights reserved.
//




import UIKit
import NVActivityIndicatorView
import Stripe



var homeBottomInset : CGFloat = 0.0
class startUpVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userNameBottomLine: UIView!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passworkBottomLine: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var startBtnView: UIView!
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    var tokenSaved = ""
    var emailSaved  = ""
    var passSaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeBottomInset = view.safeAreaInsets.bottom
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        homeBottomInset = bottomPadding!
        
        self.tokenSaved = UserDefaults.standard.object(forKey: "token") as? String ?? ""
        self.passSaved = UserDefaults.standard.object(forKey: "password") as? String ?? ""
        self.emailSaved = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        
        self.userName.text = self.emailSaved
        self.password.text = self.passSaved
        
        if self.userName.text != "" {
            self.startUpAction(self.startBtn)
        }
        else{
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initUI()
    }
    
    func initUI() {
        publicFunctions().addGradient(view: self.startBtnView, colors: [appColors.appMainColor , appColors.appMainColorForGradient], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1) ,cornerRadius: 5, left: 25 , right:  25 )
        publicFunctions().addShadow(view: self.startBtnView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.6)
        
       // publicFunctions().addGradient(view: self.createAccView, colors: [appColors.appMainColor , appColors.appMainColorForGradient], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1) ,cornerRadius: 5, left: 25 , right:  25 )
      //  publicFunctions().addShadow(view: self.createAccView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.6)
        
        
        publicFunctions().addShadow(view: self.userNameView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.6)
        userName.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        publicFunctions().addShadow(view: self.passwordView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 0.6)
        password.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        self.userName.returnKeyType = .next
        self.password.returnKeyType = .done
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getInitialData() {
        
            if Connectivity.isConnectedToInternet {
                startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
                webClient().getInitialDataFromServer( token: UserDefaults.standard.object(forKey: "token") as? String ?? "",  completionHandler: { (error, result) in
                    
                    DispatchQueue.main.async {
                        
                        self.stopAnimating(nil)
                    }
                    if error != nil {
                        Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Something went wrong.", position: .top, level: .normal)
                        return
                    } else {
                        
                        if let resultV = result as? [String : Any] {
                            
                            publicFunctions().parseInitialData(resultV: resultV)
                            
                            DispatchQueue.main.async {
                                let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                                
                                let stry = UIStoryboard(name: "main", bundle: nil)
                                rootviewcontroller.rootViewController = stry.instantiateViewController(withIdentifier: "main")
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

    @IBAction func startUpAction(_ sender: UIButton) {
        
        if Connectivity.isConnectedToInternet {
            if userName.text == "" {
                Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your email.", position: .top, level: .normal)
                return
            }
            if password.text == "" {
                Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your password.", position: .top, level: .alert)
                return
            }
            
            startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().sendHTTPRequest(parameters: ["email" :self.userName.text!, "password" : self.password.text!  ], url: apiNames.logInUrl ,  completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Email or password is incorrect.", position: .top, level: .normal)
                    return
                } else {
                    
                    if let resultV = result as? [String : Any] {
                        let user = resultV["user"] as? [String : Any] ?? [:]
                        let token = resultV["token"] as? String ?? ""
                        
                        let id = user["id"] as? Int ?? -1
                        let created_at = user["created_at"] as? String ?? "-1"
                        let updated_at = user["updated_at"] as? String ?? "-1"
                        let email = user["email"] as? String ?? "-1"
                        let phone_number = user["phone_number"] as? String ?? "-1"
                        let name = user["name"] as? String ?? "-1"
                        let stripe_customer_id = user["stripe_customer_id"] as? String ?? ""
                        let default_card_id = user["default_card_id"] as? String ?? ""
                        let email_verified_at = user["email_verified_at"] as? String ?? ""
                        let stripe_cards = user["stripe_cards"] as? [[String : Any]] ?? []
                        var stripe_temp = [StripeCard]()
                        for stripe in stripe_cards{
                            let id_stripe = stripe["id"] as? String ?? ""
                            let brand = stripe["brand"] as? String ?? ""
                            let exp_month = stripe["exp_month"] as? Int ?? -1
                            let exp_year = stripe["exp_year"] as? Int ?? -1
                            let last4 = stripe["last4"] as? String ?? ""
                            stripe_temp.append(StripeCard.init(id: id_stripe, brand: brand, expMonth: exp_month, expYear: exp_year, last4: last4))
                        }
                        
                        let userModel = UserData.init(id: id, name: name, email: email, phoneNumber: phone_number, stripeCustomerID: stripe_customer_id, stripeCards: stripe_temp, defaultCardID: default_card_id, emailVerifiedAt: email_verified_at, createdAt: created_at, updatedAt: updated_at, token: token)
                        
                        
                        
                        sharedData.userData = userModel
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(self.password.text!, forKey: "password")
                        UserDefaults.standard.set(token, forKey: "token")
                        
                        self.getInitialData()
                        
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
    
    @IBAction func createAccBtnTapped(_ sender: Any) {
        
        let strB = UIStoryboard(name: "auth", bundle: nil)
        let next = strB.instantiateViewController(withIdentifier: "signUpVC")
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension startUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.userName {
            self.userNameBottomLine.backgroundColor = appColors.appMainColor
        }
        else if textField == password {
            self.passworkBottomLine.backgroundColor = appColors.appMainColor
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.userName {
            self.userNameBottomLine.backgroundColor = UIColor.white
        }
        else if textField == password {
            self.passworkBottomLine.backgroundColor = UIColor.white
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userName {
            self.userName.resignFirstResponder()
            self.password.becomeFirstResponder()
            return true
        }
        else if textField == password {
            self.password.resignFirstResponder()
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
    
}
