//
//  savedCardCell.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/11/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class savedCardCell: UITableViewCell {
    
    @IBOutlet weak var checkImg: UIImageView!
    
    @IBOutlet weak var brand: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
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
