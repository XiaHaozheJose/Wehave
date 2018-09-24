//
//  WHHotelTableViewCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.

import UIKit
class WHHotelTableViewCell: UITableViewCell {

    fileprivate let imagesList = [#imageLiteral(resourceName: "h1.png"),#imageLiteral(resourceName: "h2.png"),#imageLiteral(resourceName: "h3.png"),#imageLiteral(resourceName: "h4.png"),#imageLiteral(resourceName: "h5.png"),#imageLiteral(resourceName: "h6.png"),#imageLiteral(resourceName: "h7.png"),#imageLiteral(resourceName: "h8.png")]
    fileprivate let ramdNumber = arc4random_uniform(8)
    lazy var apartLabel: UILabel = {
        let label = UILabel()
        label.text = "Aparthotel"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()
    var hotelModel: HotelDataModel?{
        didSet{
            guard let hotel = hotelModel else {return }
            hotelName.text = hotel.property_name
            totalPrice.text = "€\(hotel.total_price?.amount ?? "0")"
            setAmentiesImage(otaList: hotel.amentiesList)
            hotelImage.image = imagesList[Int(ramdNumber)]
            setStarImage(awards: hotel.awards)
        }
    }
    
    var daysNumber: String = "" {
        didSet{
            daysNumLabel.text = "\(daysNumber) Days"
        }
    }
    
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var otaView: UIView!
    @IBOutlet weak var scoreNumber: UILabel!
    @IBOutlet weak var daysNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // addRadius
        let rectCorner = UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue|UIRectCorner.topRight.rawValue|UIRectCorner.bottomRight.rawValue)
        scoreNumber.addCorner(roudingCorners: rectCorner, cornerSize: CGSize(width:5,height:5))

        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func setAmentiesImage(otaList:[UIImage]?){
        guard let lists = otaList else { return }
        let width: CGFloat = 16
        let height: CGFloat = 16
        let cols:Int = 6
        for (index,item) in lists.enumerated() {
            let imageView = UIImageView(image: item)
            imageView.frame = CGRect(x: CGFloat(index % cols) * (width + kCommonMargin), y: CGFloat(index / Int(cols)) * (height + kCommonMargin), width: width, height: height)
            otaView.addSubview(imageView)
        }
    }
    
    private func setStarImage(awards: [subAwardsModel]?){
        guard let awardsList = awards else { return }
        guard let subAward = awardsList.first else {
            apartLabel.frame = starView.bounds
            starView.addSubview(apartLabel)
            return }
        switch subAward.rating ?? "0"{
        case "1":
            funcSetupStar(count: 1)
        case "2":
            funcSetupStar(count: 2)
        case "3":
            funcSetupStar(count: 3)
        case "4":
            funcSetupStar(count: 4)
        case "5":
            funcSetupStar(count: 5)
        default:
            break
        }
    }
    
    private func funcSetupStar(count: Int){
        for index in 0..<count {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "star"))
            imageView.frame = CGRect(x: CGFloat(index) * (#imageLiteral(resourceName: "star").size.width + kCommonMargin ) , y: 0, width: #imageLiteral(resourceName: "star").size.width, height: #imageLiteral(resourceName: "star").size.height)
            starView.addSubview(imageView)
        }
    }
    
    override func prepareForReuse() {
        removeAllSubView(ota: otaView)
        removeAllSubView(ota: starView)
    }
    
    private func removeAllSubView(ota: UIView){
        for (_,item) in ota.subviews.enumerated(){
            item.removeFromSuperview()
        }
    }
    private func removeAllSubView(star: UIView){
        for (_,item) in star.subviews.enumerated(){
            item.removeFromSuperview()
        }
    }
    
}
