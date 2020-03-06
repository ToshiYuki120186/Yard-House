//
//  page_1Cell.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/3/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class page_1Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    

}
