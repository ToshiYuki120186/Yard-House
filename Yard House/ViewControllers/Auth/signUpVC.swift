//
//  signUpVC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/2/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit


class signUpVC: UIViewController {

    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomInset: NSLayoutConstraint!
    
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var fullNameBottomLine: UIView!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailBottomLine: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordBottomLine: UIView!
    
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var confirmPassBottomLine: UIView!
    
    @IBOutlet weak var signUpBtnView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(doneEditting))
        tap.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self,  selector:#selector(self.keyboardNotification(notification:)),                                               name:UIResponder.keyboardWillChangeFrameNotification,                                             object: nil)
        initUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI() {
        self.backImg.image = UIImage(named: "ic_back.png")?.tinted(with: UIColor.darkGray)
        publicFunctions().addGradient(view: self.signUpBtnView, colors: [appColors.appMainColor , appColors.appMainColorForGradient], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1) ,cornerRadius: 5, left: 25 , right:  25 )
        publicFunctions().addShadow(view: self.signUpBtnView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        
        publicFunctions().addShadow(view: self.fullNameView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        fullName.attributedPlaceholder = NSAttributedString(string: "Full Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        fullName.returnKeyType = .next
        
        publicFunctions().addShadow(view: self.emailView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        email.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        email.returnKeyType = .next
        
        publicFunctions().addShadow(view: self.passwordView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        password.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        password.returnKeyType = .next
        
        publicFunctions().addShadow(view: self.confirmPassView, cornerRadius: 5, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 2, height: 4), shadowOpacity: 0.6)
        confirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmPass.returnKeyType = .done
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                var endFrameY = endFrame?.origin.y ?? 0
                let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
             
                
                if endFrameY >= (UIScreen.main.bounds.size.height - homeBottomInset){
                    self.bottomInset.constant = 0
                    self.view.layoutIfNeeded()
                    self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0 , width: 50, height: 50), animated: true)
                    self.view.layoutIfNeeded()
                    self.viewWillAppear(true)
                } else {
                    self.bottomInset.constant = (endFrame?.size.height)! - homeBottomInset - 150
                    self.view.layoutIfNeeded()
                    self.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.scrollView.contentSize.height - 50 , width: 50, height: 50), animated: true)
                    self.view.layoutIfNeeded()
                    self.viewWillAppear(true)
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0.0),options: animationCurve,animations: {
                                self.view.layoutIfNeeded()
                                self.viewWillAppear(true)},completion: nil)
                
            }
        }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    //#MARK: SignUp Button Tapped.
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        if fullName.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your full name.", position: .top, level: .normal)
            return
        }
        if email.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your email.", position: .center, level: .alert)
            return
        }
        if password.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your password.", position: .center, level: .alert)
            return
        }
        if confirmPass.text == "" {
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Please input your confirm password.", position: .center, level: .alert)
            return
        }
        if publicFunctions().isValidEmailAddress(emailAddressString: self.email.text!){
            if self.password.text == self.confirmPass.text {
                
                
                registerUser.sharedInstance.fullName = self.fullName.text!
                registerUser.sharedInstance.email = self.email.text!
                registerUser.sharedInstance.password = self.password.text!
                
                let str = UIStoryboard(name: "auth", bundle: nil)
                let next = str.instantiateViewController(withIdentifier: "phoneInserVC")
                self.navigationController?.pushViewController(next, animated: true)
                
               
                
            }
            else{
                Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Confirm Password does not match.", position: .center, level: .alert)
                return
            }
        }
        else{
            Themes.sharedInstance.showAlert(form: .tabView, theme: .error, title: "Error", body: "Email is invalid.", position: .center, level: .alert)
            return
        }
        
       
    }

    @objc func doneEditting(){
        self.view.endEditing(true)
        
    }
}

extension signUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.fullName {
            self.fullNameBottomLine.backgroundColor = appColors.appMainColorForGradient
        }
        else if textField == email {
            self.emailBottomLine.backgroundColor = appColors.appMainColorForGradient
        }
        else if textField == password {
            self.passwordBottomLine.backgroundColor = appColors.appMainColorForGradient
        }
        else if textField == confirmPass {
            self.confirmPassBottomLine.backgroundColor = appColors.appMainColorForGradient
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.fullName {
            self.fullNameBottomLine.backgroundColor = UIColor.white
        }
        else if textField == email {
            self.emailBottomLine.backgroundColor = UIColor.white
        }
        else if textField == password {
            self.passwordBottomLine.backgroundColor = UIColor.white
        }
        else if textField == confirmPass {
            self.confirmPassBottomLine.backgroundColor = UIColor.white
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullName {
            self.fullName.resignFirstResponder()
            self.email.becomeFirstResponder()
            return true
        }
        else if textField == email {
            self.email.resignFirstResponder()
            self.password.becomeFirstResponder()
            return true
        }
        else if textField == password {
            self.password.resignFirstResponder()
            self.confirmPass.becomeFirstResponder()
            return true
        }
        else if textField == confirmPass {
            self.confirmPass.resignFirstResponder()
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
    
}
