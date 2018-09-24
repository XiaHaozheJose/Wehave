//
//  WHCheckTimeCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/15.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHCheckTimeCell: UITableViewCell {

    
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var countWithDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
