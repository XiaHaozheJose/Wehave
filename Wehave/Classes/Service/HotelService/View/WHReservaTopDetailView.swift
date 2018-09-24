//
//  WHReservaTopDetailView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

protocol TopDetailViewDelegate: NSObjectProtocol {
    func topDetailViewDidClick(isShow: Bool)
    
}

class WHReservaTopDetailView: UIView {
    
    
    var roomModel:subRoomsModel?{
        didSet{
            price.text = roomModel?.total_amount?.amount
            totalPrice.text = "Euro \(roomModel?.total_amount?.amount ?? "")"
        }
    }
    fileprivate var isShowMiddleView: Bool = false
    @IBOutlet weak var middleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var countDates: UILabel!
    @IBOutlet weak var exitDate: UILabel!
    @IBOutlet weak var enterDate: UILabel!
    @IBOutlet weak var typeHabitacion: UILabel!
    @IBOutlet weak var desayunoLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var countNocheBottom: UILabel!
    @IBOutlet weak var countRoom: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var menuDownBtn: UIButton!
    @IBOutlet weak var canCancelLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    
    var delegate: TopDetailViewDelegate?
    
    class func initViewWithNib()->WHReservaTopDetailView{
        let nib = UINib(nibName: "WHReservaTopDetailView", bundle: nil)
        let topView = nib.instantiate(withOwner: nil, options: nil)[0] as! WHReservaTopDetailView
        return topView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        middleView.isHidden = true
        middleViewHeight.constant = 0
        bottomView.addCorner(roudingCorners: UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue), cornerSize: CGSize(width: self.bounds.width  , height: bottomView.frame.height))
        
        let hotelInstance = HotelBooking.shared
        personLabel.text = "\(hotelInstance.adultCount)Adultos,\(hotelInstance.childCount)Ninos"
        enterDate.text = getDateWith(date: hotelInstance.startDate)
        exitDate.text = getDateWith(date: hotelInstance.endDate)
        countRoom.text = hotelInstance.roomsCount
        countDates.text = "\(hotelInstance.countDate)Noches"
        countNocheBottom.text = hotelInstance.roomsCount
    }
    
    @IBAction func clickMenuDown(_ sender: UIButton) {
        if isShowMiddleView {
            closeMiddleView()
        }else {
            openMiddleView()
        }
    }
    
    private func getDateWith(date:String)->String{
         let str = date.split(separator: "-")
        return "\(str.first ?? "")-\(str[1])"
    }
    
    func openMiddleView(){
        isShowMiddleView = true
        UIView.animate(withDuration: 0.25){
            self.middleView.isHidden = false
            self.middleViewHeight.constant = 100
            self.menuDownBtn.transform = CGAffineTransform(rotationAngle: .pi - 0.001)
        }
        delegate?.topDetailViewDidClick(isShow: true)
    }
    
    func closeMiddleView(){
        isShowMiddleView = false
        UIView.animate(withDuration: 0.25) {
            self.middleView.isHidden = true
            self.middleViewHeight.constant = 0
            self.menuDownBtn.transform = .identity
        }
        delegate?.topDetailViewDidClick(isShow: false)

    }
    
    
   
    
    

}
