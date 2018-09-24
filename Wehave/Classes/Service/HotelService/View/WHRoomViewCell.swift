//
//  WHRoomViewCell.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/27.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHRoomViewCell: UITableViewCell {

    @IBOutlet weak var habitacionLabel: UILabel!
    @IBOutlet weak var desayunoLabel: UILabel!
    @IBOutlet weak var camaLabel: UILabel!
    @IBOutlet weak var cancelFreeLabel: UILabel!
    @IBOutlet weak var reservaButton: UIButton!
    @IBOutlet weak var avalLabel: UILabel!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var sold_out_view: UIView!
    
    var reservarBlock:((subRoomsModel)->())?
    var room: subRoomsModel?{
        didSet{
            if let rm = room{
                setDatas(rm: rm)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reservaButton.addCorner(roudingCorners: UIRectCorner.init(rawValue: UIRectCorner.topLeft.rawValue|UIRectCorner.topRight.rawValue), cornerSize: CGSize(width: 5, height: 5))
        avalLabel.addCorner(roudingCorners: UIRectCorner.init(rawValue: UIRectCorner.bottomLeft.rawValue|UIRectCorner.bottomRight.rawValue), cornerSize: CGSize(width: 5, height: 5))
    }

    
    private func setDatas(rm: subRoomsModel){
        if let amount = rm.total_amount?.amount {
            if Double(amount) ?? 0.00 >= 500.00{
                roomPriceLabel.text = "Sin Precio".localized
                sold_out_view.isHidden = false
            }else {
//                roomPriceLabel.text = "\(rm.total_amount?.currency.sorted().first ?? "$")" + amount
                roomPriceLabel.text = amount + EUR
                sold_out_view.isHidden = true
            }}}
    
    @IBAction func reservaClick() {
        pushToReservaView(roomModel: room!)
    }
    
   fileprivate func pushToReservaView(roomModel: subRoomsModel){
        reservarBlock?(roomModel)
    }
    
    func setBlockWithReserva(completion:@escaping ((subRoomsModel)->())){
        reservarBlock = completion
    }
    
    
    
}
