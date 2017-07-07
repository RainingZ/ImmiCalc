//
//  DateTableViewCell.swift
//  ImmiCalc
//
//  Created by Raining on 2017-07-07.
//  Copyright © 2017 Raining. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var from_date_label: UILabel!
    @IBOutlet weak var to_date_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
