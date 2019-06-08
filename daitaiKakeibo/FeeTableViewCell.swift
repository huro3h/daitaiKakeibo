//
//  FeeTableViewCell.swift
//  daitaiKakeibo
//
//  Created by satoshiii on 2016/06/07.
//  Copyright © 2016年 satoshiii. All rights reserved.
//

import UIKit
import FontAwesomeKit

class FeeTableViewCell: UITableViewCell {

	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var foodFareLabel: UILabel!
	@IBOutlet weak var lifeFareLabel: UILabel!
	@IBOutlet weak var zappiFareLabel: UILabel!
	@IBOutlet weak var hokaFareLabel: UILabel!
	@IBOutlet weak var totalFareLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
