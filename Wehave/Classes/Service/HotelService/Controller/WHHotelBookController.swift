//
//  WHHotelBookController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/15.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
fileprivate let locationCell = "locationCell"
fileprivate let checkCell = "checkCell"
fileprivate let roomCell = "roomCell"

protocol JS_HotelBookDelagate {
    func clickWithType(type: CellType)
}

enum CellType: Int{
    case LocationCell
    case CheckTimeCell
    case PersonYRoomCell
    case MaxPrecio
}
class WHHotelBookController: UITableViewController {
    
    
    fileprivate var isShowCalendar: Bool = false
    var bookDelagate: JS_HotelBookDelagate?
    fileprivate let images:[String] = ["image1","image2","image3"]
    
    fileprivate lazy var hotelWheel:JCyclePictureView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 160)
        let cycle = JCyclePictureView(frame:frame,pictures:images)
        cycle.placeholderImage = #imageLiteral(resourceName: "image1")
        cycle.direction = .left
        cycle.autoScrollDelay = 5
        cycle.pageControlStyle = .center
        cycle.pageControl.currentPageIndicatorTintColor = ThemeColor
        cycle.pageControl.pageIndicatorTintColor = UIColor.lightGray
        return cycle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "WHLocationCell", bundle: nil), forCellReuseIdentifier: locationCell)
        tableView.register(UINib(nibName: "WHCheckTimeCell", bundle: nil), forCellReuseIdentifier: checkCell)
        tableView.register(UINib(nibName: "WHPersonYRoomCell", bundle: nil), forCellReuseIdentifier: roomCell)
        tableView.rowHeight = 60
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = HotelBooking.shared
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: locationCell, for: indexPath) as! WHLocationCell
            cell.selectionStyle = .none
            cell.destino_label.text = model.location
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: checkCell, for: indexPath) as! WHCheckTimeCell
            cell.startDateLabel.text = model.startDate
            cell.endDateLabel.text = model.endDate
            cell.countWithDate.text = model.countDate
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: roomCell, for: indexPath) as! WHPersonYRoomCell
            cell.roomLabel.text = model.roomsCount
            cell.childLabel.text = model.childCount
            cell.adultLabel.text = model.adultCount
            return cell
        default :
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil{
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell?.textLabel?.textColor = UIColor.lightGray
                cell?.textLabel?.text = model.maxAmount
            }
            return cell!
        }
    }
}


// MARK: - TableViewDelegate
extension WHHotelBookController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case CellType.LocationCell.rawValue:
            bookDelagate?.clickWithType(type: .LocationCell)
            break
        case CellType.CheckTimeCell.rawValue:
            bookDelagate?.clickWithType(type: .CheckTimeCell)
            break
        case CellType.PersonYRoomCell.rawValue:
            bookDelagate?.clickWithType(type: .PersonYRoomCell)
            break
        case CellType.MaxPrecio.rawValue:
            bookDelagate?.clickWithType(type: .MaxPrecio)
            break
        default:
            break
        }
    }
}

extension WHHotelBookController{
    private func setupUI(){
        self.tableView.tableHeaderView = hotelWheel
    }
}



