//
//  phoneInserVC.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/2/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class phoneInserVC: UIViewController {

    @IBOutlet weak var mobileNumberPlaceHolder_Lbl: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var downImg: UIImageView!
    
    var fromAccount_Vc = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        let bundle = "assets.bundle/"
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print("countryCode",countryCode)
            let get_Flag = UIImage(named: bundle + countryCode.uppercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
            let dialingCodeList = Themes.sharedInstance.getCountryList()
            let currentCode = dialingCodeList.value(forKey: countryCode.uppercased()) as? [String] ?? ["",""]
            countryImage.image = get_Flag
            codeLabel.text = "+" + currentCode[1]
            
        }
        
        

    }
    
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickMobileNumber(_ sender: Any) {
        
        
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "phoneInsertVCNext") as! phoneInsertVCNext
        loginController.fromAccount_Vc = self.fromAccount_Vc
        self.navigationController?.pushAnimationFade(controller: loginController, animated: false)
        
    }
    
 
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
