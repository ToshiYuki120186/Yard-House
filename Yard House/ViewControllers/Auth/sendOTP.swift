//
//  sendOTP.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/2/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Stripe

class sendOTP: UIViewController, NVActivityIndicatorViewable {

    
    
    @IBOutlet weak var contiueView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    
    @IBOutlet weak var otpTxt: UITextField!
    
    @IBOutlet weak var backImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
        // Do any additional setup after loading the view.
    }
    

    func initUI(){
        self.backImage.image = UIImage(named: "ic_back.png")?.tinted(with: UIColor.darkGray)
        publicFunctions().addGradient(view: self.contiueView, colors: [appColors.appMainColor , appColors.appMainColorForGradient], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1) ,cornerRadius: 5, left: 20 , right:  20 )
        publicFunctions().addShadow(view: self.contiueView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        
    }
    
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendTapped(_ sender: Any) {
        
        if let data = UserDefaults.standard.value(forKey:"user") as? Data {
            let user = try? PropertyListDecoder().decode(UserData.self, from: data)
            print(user?.createdAt)
            print("ddd")
        }
        else{
            
        }
        
        
    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet {
            startAnimating(CGSize(width: 60, height: 60), message: "",  type: NVActivityIndicatorType.ballRotateChase,  fadeInAnimation: nil)
            webClient().sendHTTPRequest(parameters: ["name" : registerUser.sharedInstance.fullName, "phone_number" : registerUser.sharedInstance.phoneNumber , "email" : registerUser.sharedInstance.email , "password" : registerUser.sharedInstance.password , "password_confirm" : registerUser.sharedInstance.password ], url: apiNames.signUpUrl ,  completionHandler: { (error, result) in
                
                DispatchQueue.main.async {
                    
                    self.stopAnimating(nil)
                }
                if error != nil {
                    Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: error!, position: .center, level: .alert)
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
                        
                        let userModel = UserData.init(id: id, name: name, email: email, phoneNumber: phone_number, stripeCustomerID: stripe_customer_id, stripeCards: stripe_temp, defaultCardID: default_card_id, emailVerifiedAt: email_verified_at, createdAt: created_at, updatedAt: updated_at , token: token)
                        
                        sharedData.userData = userModel
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(registerUser().password, forKey: "password")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
