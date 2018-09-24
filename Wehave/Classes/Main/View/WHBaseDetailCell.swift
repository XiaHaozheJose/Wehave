//
//  WHBaseDetailCell.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/22.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHBaseDetailCell: UITableViewCell {
    
    
    let imageWidth: CGFloat = 90
    let imageHeight: CGFloat = 110
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeStateImage: UIImageView!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setup(product: WHProductModel){
        let icon = WEHAVE_BASIC_LOCAL_APIs_Images + product.icon_image
        iconImage.kf.setImage(with: URL(string: icon), placeholder: #imageLiteral(resourceName: "placeholder_icon_image"))
        name.text = product.user_name
        priceLabel.text = "\(product.price) \(EUR)"
        contentLabel.text = product.content
        locationLabel.text = product.ubication.uppercased()
        lastTimeLabel.text = setTimeWithDateString(dateStr: product.creatTime)
        setContentScollView(imagesPath: product.product_images)
    }
    
    private func setTimeWithDateString(dateStr: String)->String{
        let formatter = DateFormatter()
        var timeStr = ""
        formatter.dateFormat = "HH:mm:ss dd-MM-yyyy"
        if let date = formatter.date(from: dateStr){
            let nowInterval = Date().timeIntervalSince1970
            let creatInterval = date.timeIntervalSince1970
            
            let delta = nowInterval - creatInterval
            if delta > 60 * 60 * 24, delta < 60 * 60 * 24 * 7{
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "EEE"
                timeStr = (setESWeek(week: dateFormat.string(from: date))).localized
                timeStateImage.image = #imageLiteral(resourceName: "oldPoint")
                if delta <= 60 * 60 * 24{
                    timeStr = "Hoy".localized
                    timeStateImage.image = #imageLiteral(resourceName: "normalPoint")
                }
                if delta <= 60 * 60{ // one hour
                    timeStr = "Hace una hora".localized
                    timeStateImage.image = #imageLiteral(resourceName: "newPoint")
                }
                if (delta <= 60){// one minuts
                    timeStr = "Nuevo".localized
                    timeStateImage.image = #imageLiteral(resourceName: "newPoint")
                }
            }else{
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd-mm-yyyy"
                timeStr = dateFormat.string(from: date)
            }
        }
        return timeStr
    }
    
    private func setContentScollView(imagesPath:String){
        for subImage in contentScrollView.subviews{
            subImage.removeFromSuperview()
        }
        let imagesArr = imagesPath.split(separator: ":")
        var images = [String]()
        contentScrollView.contentSize = CGSize(width: (CGFloat(imagesArr.count) * (imageWidth + kCommonMargin)), height: contentScrollView.height)
        for (index,image) in imagesArr.enumerated() {
            let imagePath  =  WEHAVE_BASIC_LOCAL_APIs_Images + image
            images.append(imagePath)
            let contentImage = UIImageView(frame: CGRect(x: (CGFloat(index) * (imageWidth + kCommonMargin)), y: kCommonMargin * 0.5, width: imageWidth, height: imageHeight))
            contentImage.kf.setImage(with: URL(string: imagePath), placeholder: #imageLiteral(resourceName: "contentImgePlaceholder"))
            contentScrollView.addSubview(contentImage)
        }
    }
    
    
    
    private func setESWeek(week: String)->String{
        switch week {
        case "Mon":
            return "Lunes".localized
        case "Tue":
            return "Martes".localized
        case "Wed":
            return "Miercoles".localized
        case "Thu":
            return "Jueves".localized
        case "Fri":
            return "Viernes".localized
        case "Sat":
            return "Sabado".localized
        default:
            return "Domingo".localized
        }
    }
    
    
}


