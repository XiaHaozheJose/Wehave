

//
//  WHHotelServiceController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/12.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
class WHHotelServiceController: UIViewController {
    
    
    // MARK: - ...Value...

    fileprivate let kCalendarHeight = kScreenHeight - (2 * kNavigationBarHeight)
    fileprivate let model = HotelBooking.shared

    // TableView List For Reservation
    lazy var centerTableView: WHHotelBookController = {
        let vc = WHHotelBookController()
        vc.tableView.frame = self.view.bounds
        vc.tableView.backgroundColor = .clear
        vc.bookDelagate = self
        return vc
    }()
        
    ///FooterView
    lazy var footerView: UIView = {
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 120)
        return footer
    }()
    
    /// ToolBar
    lazy var toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.backgroundColor = .white
        bar.frame = CGRect(x: 0, y: kScreenHeight - 64, width: kScreenWidth, height: 64)
        return bar
    }()
    
    // Back Button Cycle
    lazy var cycle: UIImageView = {
        let image = UIImageView(image:#imageLiteral(resourceName: "backcycle"))
        image.alpha = 0.5
        image.center = CGPoint(x: 30, y: 49)
        return image
    }()
    
    // Return Button <返回按钮>
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        btn.sizeToFit()
        btn.center = self.cycle.center
        btn.addTarget(self, action: #selector(backToRootView), for: .touchUpInside)
        return btn
    }()
    
    // calendarView
    fileprivate lazy var calendarView: JS_CalendarViewController = {
        let calendar = JS_CalendarViewController()
//        self.addChildViewController(calendar)
        calendar.view.frame = CGRect(x: 0, y: kScreenHeight , width: kScreenWidth, height: kCalendarHeight)
        calendar.delegate = self
        calendar.view.alpha = 0.0
        return calendar
    }()
    // HUB
    fileprivate lazy var hubView: UIView = {
       let v = UIView()
        v.frame = view.bounds
        v.backgroundColor = .black
        v.alpha = 0.3
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickHubView(tap:)))
        v.addGestureRecognizer(tap)
        return v
    }()
    // Picker
    fileprivate lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 160)
        picker.backgroundColor = ThemeColor
        let title = UILabel()
        title.text = "ELIJA TU ROOM"
        title.sizeToFit()
        title.center = CGPoint(x: picker.center.x, y: kCommonMargin * 2)
        title.textColor = .white
        picker.addSubview(title)
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // MARK: - LoadView -> LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeBackgroundColor
        setupUI()
        setSubViewInFooterView()
        setBottomIntroduceView()
        setHotelBookingData()
    }
    
}


// MARK: - Setup
private extension WHHotelServiceController{
    
    // setup UI
    func setupUI(){
        view.addSubview(centerTableView.tableView)
        view.addSubview(cycle)
        view.insertSubview(backButton, aboveSubview: cycle)
        centerTableView.tableView.tableFooterView = footerView
        view.addSubview(toolBar)
        view.addSubview(calendarView.view)
        view.addSubview(pickerView)
    }
    // Set IndtroduceView
    func setBottomIntroduceView(){
        let bottomView = WHBottomIntroduceView.introduceView()
        footerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(footerView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    private func setSubViewInFooterView(){
        // Button Busqueda
        let button = getButton(title: "Buscar", font: UIFont.systemFont(ofSize: 20, weight: .bold), titleColor: .white, imageColor: ThemeColor)
        button.addTarget(self, action: #selector(clickToSearchBooking), for: .touchUpInside)
        footerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(44)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        // button pedido
        let pedidoButton = getButton(title: "Mis Pedidos", font: UIFont.systemFont(ofSize: 20), titleColor: .black, imageColor: .white)
        footerView.addSubview(pedidoButton)
        pedidoButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(button.snp.bottom).offset(5)
            make.height.equalTo(44)
            make.width.equalTo(kScreenWidth * 0.5 - 10)
        }
        
        // button Comentario
        let comentarioButton = getButton(title: "Mi Hotel", font: UIFont.systemFont(ofSize: 20), titleColor: .black, imageColor: .white)
        footerView.addSubview(comentarioButton)
        comentarioButton.snp.makeConstraints { (make) in
            make.top.equalTo(pedidoButton)
            make.height.equalTo(pedidoButton)
            make.trailing.equalTo(button)
            make.width.equalTo(pedidoButton)
        }
    }
    
   
    // Inicial BookingData
    func setHotelBookingData(){
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location, clp, error) in
            if clp != nil{
                guard let dic = clp!.addressDictionary as? [String : AnyObject] else {return}
                let hotelrequest = HotelRequest(dict: dic)
                self.model.location = ("\(hotelrequest.Name) \(hotelrequest.SubAdministrativeArea),\(hotelrequest.ZIP)")
                self.centerTableView.tableView.reloadData()
            }
        }
        model.startDate = getDate(count: 1, dateFormatter: "dd-MM-yyyy")
        model.endDate = getDate(count: 2, dateFormatter: "dd-MM-yyyy")
        model.requestStartDate = getDate(count: 1, dateFormatter: "yyyy-MM-dd")
        model.requestEndDate = getDate(count: 2, dateFormatter: "yyyy-MM-dd")
        model.adultCount = "1"
        model.childCount = "0"
        model.countDate = "1"
        model.roomsCount = "1"
        model.maxAmount = "0 ～ 100€"
    }
    
}

// MARK: - SELECTOR TARGET
extension WHHotelServiceController{
    
    
    @objc fileprivate func clickHubView(tap: UITapGestureRecognizer){
        popCalendarView()
        popPickerView()
    }
    
    // Click To Search Hotel
    @objc fileprivate func clickToSearchBooking(){
        let showHotelViewController = WHShowHotelsViewController()
        self.navigationController?.pushViewController(showHotelViewController, animated: true)
    }
    
    // dismiss
    @objc func backToRootView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// MARK: - JS_CalendarViewControllerDelegate
extension WHHotelServiceController: JS_CalendarViewControllerDelegate{
    
    // date delegate
    func calendarConfirmStateDate(startDate: Int, endDate: Int) {
        
        let normalDate = getDateStrWith(dateFormatter: "dd-MM-yyyy", startInterval: TimeInterval(startDate), endInterval: TimeInterval(endDate))
        let requestDate = getDateStrWith(dateFormatter: "yyyy-MM-dd", startInterval: TimeInterval(startDate), endInterval: TimeInterval(endDate))
        model.startDate = normalDate["begin"] ?? ""
        model.endDate = normalDate["end"] ?? ""
        model.requestStartDate = requestDate["begin"] ?? ""
        model.requestEndDate = requestDate["end"] ?? ""
        model.countDate = "\(getNumbersOfDays(startInterval: startDate, endInterval: endDate) ?? 1)"
        centerTableView.tableView.reloadData()
        popCalendarView()
    }
    
    // pop Delegate
    func calendarPopButtonClick() {
        popCalendarView()
    }
    
    
    
    
}


// MARK: - JS_HotelBookDelagate
extension WHHotelServiceController: JS_HotelBookDelagate{
    func clickWithType(type: CellType) {
        switch type {
        case CellType.LocationCell:
            
            break
        case CellType.CheckTimeCell:
            UIView.animate(withDuration: 0.25, animations: {
                self.calendarView.view.alpha = 1.0
                self.calendarView.view.transform = CGAffineTransform.init(translationX: 0, y: -self.kCalendarHeight)
            }, completion: { (_) in
                self.addHubView(currentView: self.calendarView.view)
            })
       
        case CellType.PersonYRoomCell:
            modalPickerView()
            break
            
        case CellType.MaxPrecio:
           
            break
            
        default:
            break
        }
    }
}


// MARK: -UIPickerViewDataSource,UIPickerViewDelegate
extension WHHotelServiceController: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Simular
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "1"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row)row \(component) colum")
    }
    
}

// MARK: - Logico Calculate
extension WHHotelServiceController{
    
    // Get Button
    fileprivate func getButton(title: String, font: UIFont, titleColor: UIColor, imageColor: UIColor)->UIButton{
        let btn = UIButton()
        btn.setBackgroundImage(setColorImage(color: imageColor), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = font
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn;
    }
    
    // Get UIImage With Pure Color
    fileprivate func setColorImage(color: UIColor)->UIImage?{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    
    func getDate(count: Int,dateFormatter: String) -> String{
        var com = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        com.day! += count
        guard let date = Calendar.current.date(from: com) else { return ""}
        let timeFormate = DateFormatter()
        timeFormate.dateFormat = dateFormatter
        return timeFormate.string(from: date)
    }
    
    // caculate
    fileprivate func getDateStrWith(dateFormatter: String, startInterval: TimeInterval, endInterval: TimeInterval)->[String:String]{
        let timeFormate = DateFormatter()
        timeFormate.dateFormat = dateFormatter
        let begin =  timeFormate.string(from: Date.init(timeIntervalSince1970: startInterval))
        let end =  timeFormate.string(from: Date.init(timeIntervalSince1970: endInterval))
        return ["begin": begin,
                "end" : end]
    }
    
    fileprivate func getNumbersOfDays(startInterval: Int, endInterval: Int)->Int?{
        let startDate = Date(timeIntervalSince1970: TimeInterval(startInterval))
        let endDate = Date(timeIntervalSince1970: TimeInterval(endInterval))
        let countDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        return countDays.day
    }
    
    // popCalendar
    fileprivate func  popCalendarView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.calendarView.view.alpha = 0.0
            self.calendarView.view.transform = .identity
        }) { (_) in
            self.removeHubView()
        }
    }
    
    
    fileprivate func modalPickerView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.transform = CGAffineTransform.init(translationX: 0, y: -self.pickerView.frame.height)
        }) { (_) in
            self.addHubView(currentView: self.pickerView)
        }
    }
    fileprivate func popPickerView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.transform = .identity
        }){ (_) in
            self.removeHubView()
        }
    }
    
    fileprivate func addHubView(currentView: UIView){
        view.insertSubview(hubView, belowSubview:currentView)
    }
    fileprivate func removeHubView(){
       hubView.removeFromSuperview()
    }
}



