//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages
import Kingfisher

class TacoDialogView: MessageView {

    fileprivate static var tacoTitles = [
        1 : "Just one, Please",
        2 : "Make it two!",
        3 : "Three!!!",
        4 : "Cuatro!!!!",
    ]

    var getTacosAction: ((_ count: Camp) -> Void)?
    var cancelAction: (() -> Void)?
    var camp : Camp!
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var availables: UILabel!
    @IBOutlet weak var begin: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override  func awakeFromNib() {
        
        
        
    }
    
    override func layoutSubviews() {
        self.name.text = self.camp.name
        let url_str = self.camp.image
        let url = URL(string: url_str)
        let processor = DownsamplingImageProcessor(size: self.faceImage.frame.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        self.faceImage.kf.indicatorType = .activity
        self.faceImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.png"), options: [.processor(processor),.scaleFactor(UIScreen.main.scale),.transition(.fade(1)),.cacheOriginalImage])
        
        var availabels = String()
        for iStrings in camp.campHours{
            availabels += "\(publicFunctions().getDayString(intDay: iStrings.day)) \(iStrings.startTime) - \(iStrings.endTime)\n"
        }
        self.availables.text = availabels
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self.camp.beginDate)!
        
        dateFormatter.dateFormat = "MMM dd"
        self.begin.text = dateFormatter.string(from: date)
        
        self.price.text = "price: $\(publicFunctions().getTwodigitString(dbl: Double(self.camp.price)))"
        
        self.age.text = "Age: \(self.camp.age)"
        self.desc.text = self.camp.campDescription!
        
        
        
        
        publicFunctions()
    }
    
    @IBAction func getTacos() {
        getTacosAction?(self.camp)
    }

    @IBAction func cancel() {
        cancelAction?()
    }
    
    
    @IBAction func tacoSliderSlid(_ slider: UISlider) {
      //  count = Int(slider.value)
    }
    
    @IBAction func tacoSliderFinished(_ slider: UISlider) {
      //  slider.setValue(Float(count), animated: true)
    }
}
