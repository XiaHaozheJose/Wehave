//
//  WHLocationCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/15.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreLocation
class WHLocationCell: UITableViewCell {

    fileprivate var hotel: HotelRequest? {
        didSet{
            self.destino_label.text = ("\(hotel?.Name ?? "" ) \(hotel?.SubAdministrativeArea ?? ""),\(hotel?.ZIP ?? "")")
        }
    }
    @IBOutlet weak var destino_label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("select Location")
        // Configure the view for the selected state
    }
    
    @IBAction func getLocationClick(_ sender: UIButton) {
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { [weak self](location: CLLocation?, clp:CLPlacemark?, error:NSError?) in
            guard let placemark = clp else {return}
            guard let dic = placemark.addressDictionary as? [String : AnyObject] else {return}
            self?.hotel = HotelRequest.init(dict: dic)
        }
    }
}
