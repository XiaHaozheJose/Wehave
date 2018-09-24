//
//  JS_CalendarViewController.swift
//  JS_Calendar
//
//  Created by JS_Coder on 2018/3/28.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import UIKit

protocol JS_CalendarViewControllerDelegate {
    func calendarConfirmStateDate(startDate: Int, endDate: Int)
    func calendarPopButtonClick()
}
/// Show Calendar Type
///
/// - LAST_TYPE: Only before the current month
/// - MIDDLE_TYPE: Show half of each
/// - NEXT_TYPE: Show after the current month.
enum JS_CalendarViewType: Int{
    case LAST_TYPE
    case MIDDLE_TYPE
    case NEXT_TYPE
    case NONE
}
class JS_CalendarViewController: UIViewController,UICollectionViewDataSource {
    
    fileprivate let CalendarIdentifier = "calendarCell"
    fileprivate let CalendarHeaderIdentifier = "calendarHeader"
    
    var startDate: Int = 0 // Start Date
    var endDate: Int = 0 // End Date
    var limitMonth: Int = 12 // Limit Month
    var showType: JS_CalendarViewType = .NEXT_TYPE
    
    var canTouchAfterCurrentDay: Bool = true
    var canTouchBeforeCurrentDay: Bool = false
    
    var showMoonHoliday: Bool = false // 农历节日
    var showMoonCalendar: Bool = false // 农历
    
    var delegate: JS_CalendarViewControllerDelegate?
    
    var popView: JS_CalendarPopView?
    var titleLabel: UILabel?
    var backButton: UIButton?
    lazy var collection: UICollectionView = {
        let itemSize = setScaleSize(size: CGSize(width: 50, height: 60))
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.headerReferenceSize = CGSize(width:UIScreen.main.bounds.width,height: kTabBarHeight)
        
        let collection = UICollectionView(frame: CGRect.init(x: 0,
                                                             y:titleLabel?.frame.maxY ?? kNavigationBarHeight,
                                                             width: UIScreen.main.bounds.width,
                                                             height: self.view.frame.height - kNavigationBarHeight - CALENDAR_WEEKVIEW_HEIGHT),
                                          collectionViewLayout: flowLayout)
        collection.backgroundColor = .white
        collection.register(UINib.init(nibName: "JS_CalendarCell", bundle: nil),
                            forCellWithReuseIdentifier: CalendarIdentifier)
        collection.register(UINib.init(nibName: "JS_CalendarReusableView", bundle: nil),
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: CalendarHeaderIdentifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var titleView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarHeight)
        v.backgroundColor = ThemeColor
        return v
    }()
    
    
    
    fileprivate var dataArray: [JS_CalendarHeaderModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popView?.removeFromSuperview()
        popView = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collection.frame.size.height = self.view.frame.height - kNavigationBarHeight - CALENDAR_WEEKVIEW_HEIGHT
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: CalendarIdentifier, for: indexPath) as! JS_CalendarCell
        guard  let headerItem = dataArray?[indexPath.section] else {return cell}
        guard let calendarItem = headerItem.calendarItemArray?[indexPath.row] else {return cell}
        cell.dateLabel.text = ""
        cell.subLabel.text = ""
        cell.dateLabel.textColor = CALENDAR_TEXT_COLOR
        cell.subLabel.textColor = CALENDAR_SELECT_SUBTEXT_COLOR
        cell.isSelected = false
        cell.isUserInteractionEnabled = false
        if calendarItem.day > 0 {
            cell.dateLabel.text = "\(calendarItem.day)"
            cell.subLabel.text = "\(calendarItem.holiday)"
            cell.isUserInteractionEnabled = true
        }
        // Begin Date
        if calendarItem.dateInterval == startDate{
            cell.isSelected = true
            cell.dateLabel.textColor = CALENDAR_SELECT_TEXT_COLOR
            cell.subLabel.text = "Begin"
            // End Date
        }else if calendarItem.dateInterval == endDate{
            cell.isSelected = true
            cell.dateLabel.textColor = CALENDAR_SELECT_TEXT_COLOR
            cell.subLabel.text = "End"
            
        }else if calendarItem.dateInterval > startDate && calendarItem.dateInterval < endDate{
            cell.isSelected = true
            cell.dateLabel.textColor = CALENDAR_SELECT_TEXT_COLOR
        }else {
            
        }
        if !canTouchAfterCurrentDay{
            if calendarItem.type == .CALENDAR_NEXT{
                cell.dateLabel.textColor = CALENDAR_UNABLETOUCH_TEXT_COLOR
                cell.isUserInteractionEnabled = false
            }
        }
        if !canTouchBeforeCurrentDay {
            if calendarItem.type == .CALENDAR_LAST{
                cell.dateLabel.textColor = CALENDAR_UNABLETOUCH_TEXT_COLOR
                cell.isUserInteractionEnabled = false
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let headerItem = dataArray?[section] else {return 0}
        return headerItem.calendarItemArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalendarHeaderIdentifier, for: indexPath) as! JS_CalendarReusableView
        guard let headerItem = dataArray?[indexPath.section] else {return header}
        header.headerLabel.text = headerItem.headerText
        return header
    }
    
}

private extension JS_CalendarViewController{
    func initDataSource(){
        //        DispatchQueue.main.async {
        let manager = JS_CalendarManeger.init(showChineseHoliday: self.showMoonHoliday, showChineseCalendar: self.showMoonCalendar, startDate: self.startDate)
        let tempDateArray = manager.getCalendarDataSource(limitMounth: self.limitMonth, type: self.showType)
        self.dataArray = tempDateArray
        self.showCollectionViewWithStartIndexPath(startIndexPath: manager.startIndexPath)
        //        }
    }
    
    func setupUI(){
        view.addSubview(collection)
        view.addSubview(titleView)
        setTitleLabel()
        setWeekView()
        setPopButton()
    }
    
    // Get Size Of Scale
    func setScaleSize(size: CGSize)->CGSize{
        let width = size.width * UIScreen.main.bounds.width / 375.0
        let height = size.height * UIScreen.main.bounds.width / 375.0
        return CGSize(width: width, height: height)
    }
    
    func showCollectionViewWithStartIndexPath(startIndexPath: IndexPath?){
        
        collection.reloadData()
        if startIndexPath != nil {
            collection.scrollToItem(at: startIndexPath!, at: UICollectionViewScrollPosition.top, animated: false)
        }else {
            if (showType == .LAST_TYPE){
                if dataArray?.count != nil && dataArray!.count > 0{
                    collection.scrollToItem(at: IndexPath.init(row: 0, section: dataArray!.count - 1), at: UICollectionViewScrollPosition.top, animated: false)
                }
            }else if showType == .MIDDLE_TYPE{
                if dataArray?.count != nil && dataArray!.count > 0{
                    collection.scrollToItem(at: IndexPath.init(row: 0, section: (dataArray!.count - 1)/2), at: UICollectionViewScrollPosition.top, animated: false)
                    collection.contentOffset = CGPoint(x: 0, y: (collection.contentOffset.y) - CGFloat(49))
                }}}
    }
    
    func setTitleLabel(){
        titleLabel = UILabel()
        titleLabel?.text = "SELECT DATE"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel?.sizeToFit()
        titleLabel?.center.x = titleView.center.x
        titleLabel?.textColor = .white
        titleView.addSubview(titleLabel!)
    }
    
    func setWeekView(){
        let width = UIScreen.main.bounds.width
        let weekView = UIView(frame:CGRect(x: 0, y: kNavigationBarHeight - CALENDAR_WEEKVIEW_HEIGHT,
                                           width: width, height: CALENDAR_WEEKVIEW_HEIGHT))
        titleView.addSubview(weekView)
        let itemSize = setScaleSize(size: CGSize(width: 54, height: 60))
        let weekTitles = ["D","L","M","X","J","V","S"]
        for index in 0..<7 {
            let label = UILabel(frame: CGRect(x: CGFloat(index) * itemSize.width, y: 0, width: itemSize.width, height: CALENDAR_WEEKVIEW_HEIGHT))
            label.backgroundColor = .clear
            label.text = weekTitles[index]
            label.font = UIFont.boldSystemFont(ofSize: 16.0)
            label.textAlignment = .center
            if (index == 0 || index == 6){
                label.textColor = .red
            }else{
                label.textColor = CALENDAR_TEXT_COLOR
            }
            weekView.addSubview(label)
        }
    }
    
    func setPopButton(){
        let button = UIButton()
        button.setTitle("Volver".localized, for: .normal)
        button.frame.origin = CGPoint(x: 10, y: 0)
        button.addTarget(self, action: #selector(volverClick), for: .touchUpInside)
        button.setTitleColor(.cyan, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.sizeToFit()
        titleLabel?.center.y = button.center.y
        titleView.addSubview(button)
    }
    
    @objc func volverClick(){
        popView?.removeFromSuperview()
        popView = nil
        delegate?.calendarPopButtonClick()
    }
    
}


extension JS_CalendarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let headerItem = dataArray?[indexPath.section] else {return}
        guard let calendarItem = headerItem.calendarItemArray?[indexPath.row] else { return }
        if startDate == 0 {
            startDate = calendarItem.dateInterval
            showPopView(index: indexPath)
        }else if startDate > 0 && endDate > 0{
            startDate = calendarItem.dateInterval
            endDate = 0
            showPopView(index: indexPath)
        }else {
            if startDate < calendarItem.dateInterval{
                endDate = calendarItem.dateInterval
                delegate?.calendarConfirmStateDate(startDate: startDate, endDate: endDate)
                popView?.removeFromSuperview()
            }else {
                startDate = calendarItem.dateInterval
                showPopView(index: indexPath)
            }
        }
        collectionView.reloadData()
    }
    
    private func showPopView(index: IndexPath){
        popView?.removeFromSuperview()
        popView = nil
        
        var arrowPosition: JS_CalendarPopViewPosition = .POP_MIDDLE
        let position: Int = index.row % 7
        if position == 0 {
            arrowPosition = .POP_LEFT
        }else if (position == 6){
            arrowPosition = .POP_RIGHT
        }
        
        let cell = collection.cellForItem(at: index) as! JS_CalendarCell
        popView = JS_CalendarPopView.init(sideView:cell.dateLabel , arrowPosition: arrowPosition)
        popView?.topText = "Select Checkout Day"
        let date = Date.init(timeIntervalSince1970: TimeInterval(startDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let startString = "Desde el dia " + dateFormatter.string(from:date )
        let com = Calendar.current.dateComponents([.month,.hour], from: date)
        popView?.bottomText = startString + " del \(months[com.month! - 1])"
        popView?.showAnimation()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        popView?.removeFromSuperview()
        popView = nil
    }
    
}
