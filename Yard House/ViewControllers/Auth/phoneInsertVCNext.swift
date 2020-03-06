//
//  phoneInsertVCNext.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/2/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class phoneInsertVCNext:UIViewController , MICountryPickerDelegate, UISearchBarDelegate, UITextFieldDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var expolreBtn: UIButton!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryPickBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueViewBottomHeight: NSLayoutConstraint!
    
    
    var countryFlag_Img:UIImage = UIImage()
    var iso_Code:String = String()
    var fromAccount_Vc = false
    
    let themeColor = appColors.appMainColorForGradient
// ==================================================================================================
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.mobileField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.continueViewBottomHeight.constant = keyboardHeight

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.continueViewBottomHeight.constant = 0
    }
    
    func setView() {

        self.mobileView.layer.cornerRadius = 5
        self.mobileView.layer.borderColor = UIColor.lightGray.cgColor
        self.mobileView.layer.borderWidth = 2
        self.mobileView.layer.masksToBounds = true
        
        self.backImg.image = UIImage(named: "ic_back.png")?.tinted(with: UIColor.darkGray)
        self.mobileField.becomeFirstResponder()
        self.expolreBtn.layer.cornerRadius = self.expolreBtn.frame.height / 2
        self.expolreBtn.backgroundColor = self.themeColor

        
        _ = Themes.sharedInstance.draw_Shadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true, object:expolreBtn,type:"half",cornerRadius:self.expolreBtn.frame.height / 2)
        
        let bundle = "assets.bundle/"

        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print("countryCode",countryCode)
            let get_Flag = UIImage(named: bundle + countryCode.uppercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            let dialingCodeList = Themes.sharedInstance.getCountryList()
            let currentCode = dialingCodeList.value(forKey: countryCode.uppercased()) as? [String] ?? ["",""]
            countryImage.image = get_Flag
            codeLabel.text = "+" + currentCode[1]

        }
     
        self.countryPickBtn.addTarget(self, action: #selector(countryPickerAction), for: .touchUpInside)
        self.expolreBtn.addTarget(self, action: #selector(validateMobileNumber), for: .touchUpInside)
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
    
    // MARK: - MICountryPicker
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String)
    {
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
    
    func callRegisterMobileNumber() {
//         Themes.sharedInstance.activityView(View: self.view)
//
//        let param = ["phone_number"    : "\(mobileField!.text ?? "")",
//                    "country_code"    : "\(codeLabel.text ?? "")" ]
//
//        URLhandler.sharedinstance.makeCall(url: Constant.sharedInstance.verifyPhoneNumber, param: param as NSDictionary) { (response, error) -> () in
//             Themes.sharedInstance.removeActivityView(View: self.view)
//
//                if(error != nil)
//                {
//                    self.view.makeToast(Constant.sharedInstance.errorMessage , duration: 3.0, position: .center)
//                    print(error ?? "defaultValue")
//                }
//                else{
//
//                    let result = response! as? [String:Any] ?? [:]
//                    print(result)
//                    let status = Themes.sharedInstance.checkNullvalue(Passed_value: result["status"])
//                    let message = Themes.sharedInstance.checkNullvalue(Passed_value: result["message"])
//
//                    if status == "1" {
//                        let data = result["data"] as? [String:Any] ?? [:]
//                        let mode = Themes.sharedInstance.checkNullvalue(Passed_value: data["mode"])
//                        let otp = Themes.sharedInstance.checkNullvalue(Passed_value: data["otp"])
//                        let user_status = Themes.sharedInstance.checkNullvalue(Passed_value: data["user_status"])
//
//                        let otp_Details = OTPDetails.init(country_Code: "\(self.codeLabel.text!)", phone_No: "\(self.mobileField!.text!)", otp_No: otp, message: message, user_Status: user_status, flag_Img: (self.countryImage.image)!, mode: mode)
//
//                        self.pushToOTPvc(otpDetail: otp_Details)
//
//                    }else{
//                         self.view.makeToast(message , duration: 3.0, position: .bottom)
//                    }
//
//                }
//        }
        
    }
    
    func pushToOTPvc(otpDetail:OTPDetails) {
      
//        let OtpVC = self.storyboard?.instantiateViewController(withIdentifier: "NewOTPViewController") as! NewOTPViewController
//        OtpVC.otpDlts_Struct = otpDetail
//        OtpVC.fromAccount_Vc = self.fromAccount_Vc
//        self.navigationController?.pushAnimationFade(controller: OtpVC, animated: false)
    }
    
    @objc func validateMobileNumber(){

//        var mobileNumber:String = mobileField.text!
//        mobileNumber = mobileNumber.trimmingCharacters(in:.whitespaces)
//
//        if mobileNumber.count == 0 || mobileNumber.count < 6 || mobileNumber.count > 15 {
//            self.view.makeToast("Please enter valid mobile number", duration: 1, position: .center)
//        }else if (mobileNumber.count >= 6) {
//            callRegisterMobileNumber()
//        } else {
//            self.view.makeToast("Please enter valid mobile number", duration: 1, position: .center)
//
//        }
    }
    
    @objc func loginInEmail(){
//        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func skipToExploreBtn(_ sender: Any) {
        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        appDelegate?.setInitialViewController(from:"explore")
    }
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popAnimationFade(animated: false)
        
    }
    
    // MARK: - Text field delegate method
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count ?? 0 > 14 && string != ""{
            return false
        }
        return true
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if self.mobileField.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your mobile number.", position: .center, level: .alert)
            return
        }
        else{
            registerUser.sharedInstance.phoneNumber = self.mobileField.text!
            
            let loginController = self.storyboard?.instantiateViewController(withIdentifier: "sendOTP")
            self.navigationController?.pushAnimationFade(controller: loginController!, animated: false)
            
        }
        
        
    }
    
    


}
