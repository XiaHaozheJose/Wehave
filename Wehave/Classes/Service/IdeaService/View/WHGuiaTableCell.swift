//
//  WHGuiaTableCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/6.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreLocation
class WHGuiaTableCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var previaWeb: UIWebView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 25
        iconImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(guia:GuiaModel){
        if let token = guia.user_token {
            let imagePath = WEHAVE_BASIC_LOCAL_APIs_Images + token + "_icon.png"
            iconImage.kf.setImage(with: URL(string: imagePath), placeholder: #imageLiteral(resourceName: "placeholder_icon_image"))
        }
        if let lat = guia.latitud, let log = guia.longitud{
           let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(log))
            LocationManager.sharedInstance.getReverseGeoCodedLocation(location: location) { (location, clp, error) in
                if let clp = clp{
                    self.directionLabel.text = clp.locality
                }
            }
        }
        
        if let time = guia.createTime {
            timeLabel.text = time
        }
        
        if let html = guia.htmlStr{
            previaWeb.loadHTMLString(html, baseURL: nil)
        }
    }
    
}
