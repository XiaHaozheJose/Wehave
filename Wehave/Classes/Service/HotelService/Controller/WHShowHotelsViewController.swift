//
//  WHShowHotelsViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreLocation
class WHShowHotelsViewController: UIViewController {
    
    fileprivate let showCellIdentifier = "SHOWCELL"
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dataBackgroundView: UIView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var numberOfAdult: UILabel!
    @IBOutlet weak var numberOfChild: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var maxPriceButton: UIButton!
    @IBOutlet weak var showHotelInMap: UIButton!
    @IBOutlet weak var hotelsTableView: UITableView!
    @IBOutlet weak var directionLabl: UILabel!
    
    fileprivate let reservaModel = HotelBooking.shared
    fileprivate var hotelsModelList: [HotelDataModel] = [HotelDataModel](){
        didSet{
            hotelsTableView.reloadData()
        }
    }
    lazy var loading: JSLoadingView = {
        let loading = JSLoadingView()
        loading.frame.size = CGSize(width: 50, height: 50)
        loading.center = self.view.center
        return loading
    }()
    
    // MARK: - CycleLife
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setInicialData()
        prepareToGetData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - Setup UI
private extension WHShowHotelsViewController{
    func setup(){
        hotelsTableView.dataSource = self
        hotelsTableView.delegate = self
        hotelsTableView.rowHeight = 110
        hotelsTableView.register(UINib(nibName: "WHHotelTableViewCell", bundle: nil),forCellReuseIdentifier:showCellIdentifier )
        dataBackgroundView.layer.cornerRadius = dataBackgroundView.frame.height * 0.5
    }
    
    func setInicialData(){
        startDate.text = reservaModel.startDate
        endDate.text = reservaModel.endDate
        
        numberOfAdult.text = reservaModel.adultCount
        numberOfChild.text = reservaModel.childCount
        
    }
    private func adapterOtaImagen(amenties: NSArray)->[UIImage]?{
        var otaList = [UIImage]()
        for (_,element) in amenties.enumerated() {
            guard let amentie = element as? subAmentiesModel else { return otaList }
            switch amentie.ota_code {
            case OTA.ACCESSIBLE_FACILITIES.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_acceible_facilities"))
            case OTA.BABY_SITTING.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_baby"))
            case OTA.BALLROOM.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_fitness"))
            case OTA.WIRELESS.rawValue, OTA.INTERNET_SERVICES.rawValue,OTA.INTERNET_PUBLIC_AREAS.rawValue
                ,OTA.FREE_HIGH_SPEED_INTERNET.rawValue:
                if otaList.contains(#imageLiteral(resourceName: "ota_wifi")){ break}
                otaList.append(#imageLiteral(resourceName: "ota_wifi"))
            case OTA.BEAUTY_SALON.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_beauty"))
            case OTA.COFFEE_SHOP.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_coffee"))
            case OTA.CURRENCY_EXCHANGE.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_currency"))
            case OTA.RESTAURANT.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_restaurante"))
            case OTA.PARKING.rawValue,OTA.INDOOR_PARKING.rawValue:
                if otaList.contains(#imageLiteral(resourceName: "ota_parking")){ break}
                otaList.append(#imageLiteral(resourceName: "ota_parking"))
            case OTA.PETS.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_pets"))
            case OTA.POOL.rawValue,OTA.OUTDOOR_POOL.rawValue:
                if otaList.contains(#imageLiteral(resourceName: "ota_swim")){ break}
                otaList.append(#imageLiteral(resourceName: "ota_swim"))
            case OTA.JACUZZI.rawValue,OTA.SAUNA.rawValue :
                if otaList.contains(#imageLiteral(resourceName: "ota_massage_spa")){ break}
                otaList.append(#imageLiteral(resourceName: "ota_massage_spa"))
            case OTA.LOUNGE_BARS.rawValue,OTA.NIGHTCLUB.rawValue,OTA.DISCO.rawValue:
                if otaList.contains(#imageLiteral(resourceName: "ota_bar")){ break}
                otaList.append(#imageLiteral(resourceName: "ota_bar"))
            case OTA.GIFT_SHOP.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_shopping"))
            case OTA.ROOM_SERVICE.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_room_serve"))
            case OTA.LAUNDRY_SERVICE.rawValue:
                otaList.append(#imageLiteral(resourceName: "ota_layndry"))
            default:
                break;
            }
        }
        return otaList
    }
}


// MARK: - SELECTOR ACTION
extension WHShowHotelsViewController{
    
    @IBAction func clickToPopView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToShowHotelsInMap() {
        
    }
    
    @IBAction func clickFilterBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func clickDistanceBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func clickSetPriceBtn(_ sender: UIButton) {
        
    }
}


// MARK: - NETWORKING REQUEST
extension WHShowHotelsViewController{
    
    func prepareToGetData(){
        let model = HotelBooking.shared
        LocationManager.sharedInstance.getReverseGeoCodedLocation(address:model.location) { (location, plcemark, error) in
            guard let loc = location else { return }
            self.setHotelRequestWith(location: loc, radius: 10, currency: "EUR", max_rate: "100",number_of_results:20,lang: "ES")
        }
    }
    
    fileprivate func setHotelRequestWith(location: CLLocation,radius: Int? = 42,currency: String? = "EUR",max_rate: String? = "200",number_of_results: Int? = 20,lang: String? = "EN") {
        let model = HotelBooking.shared
        let request = "\(Amadeus_APIs_Url)\(Amadeus_Hotel_Circle_Search)apikey=\(Amadeus_apikey)&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&radius=\(radius!)&check_in=\(model.requestStartDate)&check_out=\(model.requestEndDate)&currency=\(currency!)&max_rate=\(max_rate!)&number_of_results=\(number_of_results!)&lang=\(lang!)"
        print(request)
        view.addSubview(loading)
        Networking.sharedInstance.getRequest(urlString: request, success: {[weak self] (response) in
            self?.serializeJsonToModel(json: response)
        }) { (error) in
            self.loading.removeFromSuperview()
        }
    }
    
    
    private func serializeJsonToModel(json: [String: AnyObject]){
        guard let results = json["results"] as? [[String: AnyObject]] else {return}
        self.loading.removeFromSuperview()
        var tempList = [HotelDataModel]()
        for (_,element) in results.enumerated() {
            let model = HotelDataModel(dict: element)
            if let amenties = model.amenities as NSArray?{
                model.amentiesList = adapterOtaImagen(amenties: amenties)
            }
            tempList.append(model)
        }
        hotelsModelList = tempList
        print("有\(hotelsModelList.count)个酒店")
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension WHShowHotelsViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return hotelsModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: showCellIdentifier, for: indexPath) as! WHHotelTableViewCell
        cell.hotelModel = hotelsModelList[indexPath.row]
        cell.daysNumber = reservaModel.countDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = hotelsModelList[indexPath.row]
        let desHotel = WHHotelDescriptionController()
        desHotel.hotelModel = model
        self.navigationController?.pushViewController(desHotel, animated: true)
    }
    
    
}
