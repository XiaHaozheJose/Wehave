//
//  JS_CalendarCell.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/4/1.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import UIKit

class JS_CalendarCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: JS_CircleLabel!
    @IBOutlet weak var subLabel: UILabel!
    override var isSelected: Bool {
        didSet{
            dateLabel.isSelected = isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.textColor = .red
    }
    
    

}
