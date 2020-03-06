//
//  selectDefaultCardCell.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/14/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class selectDefaultCardCell: UITableViewCell {

    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var cellBack: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
