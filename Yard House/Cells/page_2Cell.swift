//
//  page_2Cell.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/4/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit

class page_2Cell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var numberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
