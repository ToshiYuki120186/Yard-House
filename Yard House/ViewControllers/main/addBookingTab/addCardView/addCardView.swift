//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages
import Stripe
import Toast_Swift
import NVActivityIndicatorView

class addCardView : MessageView , UITextViewDelegate{

    @IBOutlet weak var cardField: STPPaymentCardTextField!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var total_amount: UILabel!
    
    var ss = STPPaymentCardTextField()
    var MakePayment: ((_ token : String , _ is_save : Bool , _ stripeCard : StripeCard , _ comment : String ) -> Void)?
    var cancel: (() -> Void)?
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentText: UITextView!
    
    
    var item_id : Int!
    var duration : Int!
    var player_number : Int!
    var book_time : String!
    var amount : Double!
    
    override  func awakeFromNib() {
        
        //self.cardField.postalCodeEntryEnabled = true
        self.saveSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.commentView.layer.cornerRadius = 3
        self.commentView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentView.layer.borderWidth = 1
        self.commentText.delegate = self
        self.cardField.becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        self.total_amount.text = "Payment to pay: $ " + publicFunctions().getTwodigitString(dbl: Double(self.amount))
    }
    
    
    @IBAction func makePayment(_ sender: Any) {
        
        
        if self.cardField.cardNumber == nil || self.cardField.cardNumber == "" || self.cardField.expirationYear == 0 || self.cardField.expirationMonth == 0 || self.cardField.cvc == nil || self.cardField.cvc == "" {
            
            var style = ToastStyle()
            style.messageColor = UIColor.white
            self.backgroundView.makeToast("Please input all fields", duration: 2.0, position: .top, style: style)
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
                    
                    print(error?.localizedDescription)
                    var style = ToastStyle()
                    style.messageColor = UIColor.white
                    self.backgroundView.makeToast("error?.localizedDescription", duration: 2.0, position: .top, style: style)
                      return
                  }
                
                let cardS = StripeCard.init(id: token.card!.cardId, brand: STPCard.string(from: token.card!.brand), expMonth: Int(token.card!.expMonth), expYear: Int(token.card!.expYear), last4: token.card!.last4)
                self.MakePayment?(token.tokenId ,self.saveSwitch.isOn , cardS, self.commentText.text! )
                
                print("card Token is " ,token.card?.brand)
                print("card Token is " ,token.card?.last4)
                print(token.type.rawValue)
                print(STPCard.string(from: token.card!.brand))
                
            }
        }
  
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.cancel?()
    }
    
}
