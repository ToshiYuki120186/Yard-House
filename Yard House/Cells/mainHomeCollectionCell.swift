//
//  mainHomeCollectionCell.swift
//  Yard House
//
//  Created by TorenFrank on 2019/12/25.
//  Copyright © 2019 OnOuchs. All rights reserved.
//

import UIKit

class mainHomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        publicFunctions().addShadow(view: self.cellBackground, cornerRadius: 5, shadowColor: UIColor.lightGray, shadowOffset: CGSize(width: 2, height: 2), shadowOpacity: 0.8)
    }
    
    
}
