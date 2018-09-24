//
//  HotelResponseData.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation

class HotelDataModel: NSObject {
    @objc var property_code: String = ""    // Code Hotel
    @objc var property_name: String = ""    //Hotel
    @objc var marketing_text: String = ""
    var amentiesList: [UIImage]?
    @objc var location: subLocationModel?
    @objc var address: subAddressModel?
    @objc var total_price: subPriceModel?
    @objc var min_daily_rate: subPriceModel?
    @objc var contacts: [subContactModel]?
    @objc var amenities: [subAmentiesModel]?
    @objc var awards: [subAwardsModel]?
    @objc var rooms: [subRoomsModel]?
    @objc var _links: subMoreLinksModel?
    init(dict:[String: AnyObject]) {
        super.init()
        for key in dict.keys {
            switch key{
            case "location":
                location = subLocationModel(dict: dict[key] as! [String: AnyObject])
            case "address":
                address = subAddressModel(dict: dict[key] as! [String: AnyObject])
            case "total_price":
                total_price = subPriceModel(dict: dict[key] as! [String: AnyObject])
            case "min_daily_rate":
                min_daily_rate = subPriceModel(dict: dict[key] as! [String: AnyObject])
            case "contacts":
                contacts = [subContactModel]()
                if let cont = dict[key] as? NSArray{
                    for (_,element) in cont.enumerated(){
                        contacts?.append(subContactModel(dict: element as! [String: AnyObject]))
                    }
                }
            case "amenities":
                amenities = [subAmentiesModel]()
                if let amen = dict[key] as? NSArray{
                    for (_,element) in amen.enumerated(){
                        amenities?.append(subAmentiesModel(dict: element as! [String: AnyObject]))
                    }
                }
            case "awards":
                awards = [subAwardsModel]()
                if let award = dict[key] as? NSArray{
                    for (_,element) in award.enumerated(){
                        awards?.append(subAwardsModel(dict: element as! [String: AnyObject]))
                    }
                }
            case "rooms":
                rooms = [subRoomsModel]()
                if let room = dict[key] as? NSArray{
                    for (_,element) in room.enumerated(){
                        rooms?.append(subRoomsModel(dict: element as! [String: AnyObject]))
                    }
                }
            case "_links":
                _links = subMoreLinksModel(dict: dict[key] as! [String: AnyObject])
            case "property_code":
                property_code = dict[key] as? String ?? ""
            case "property_name":
                property_name = dict[key] as? String ?? ""
            case "marketing_text":
                marketing_text = dict[key] as? String  ?? ""
            default:
                break
            }
        }
    }
}

class subLocationModel: NSObject{
    @objc var latitude: Float = 0
    @objc var longitude: Float = 0
   
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         
    }
}

class subPriceModel: NSObject {
    @objc var amount: String = ""
    @objc var currency: String = ""

    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         
    }
}

class subAddressModel: NSObject{
    @objc var line1: String = ""
    @objc var city: String = ""
    @objc var region: String = ""
    @objc var postal_code: String = ""
    @objc var country: String = ""
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         
    }
}

class subContactModel: NSObject{
    @objc var type: String = ""
    @objc var detail: String = ""
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
    }
}

class subAmentiesModel: NSObject {
    @objc var amenity: String = ""
    @objc var ota_code: Int = -1
    @objc var detalle: String = ""
    
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key.elementsEqual("description") {
            guard let valor = value as? String else {return}
            detalle = valor
        }
    }
    
}

class subAwardsModel: NSObject{
    @objc var provider: String?
    @objc var rating: String?
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         
    }
}

class subRoomsModel: NSObject{
    @objc var booking_code: String = ""
    @objc var room_type_code: String = ""
    @objc var rate_plan_code: String = ""
    @objc var total_amount:subPriceModel?
    @objc var rates:[subRateModel]?
    @objc var descriptions: [String]?
    @objc var room_type_info: subRoomTypeModel?
    @objc var rate_type_code: String = ""
   
    init(dict:[String: AnyObject]) {
        super.init()
        for key in dict.keys {
            if key == "rates"{
                rates = [subRateModel]()
                if let rate = dict[key] as? NSArray{
                    for (_,element) in rate.enumerated(){
                        rates?.append(subRateModel(dict: element as! [String: AnyObject]))
                    }
                }
            } else if key == "booking_code"{
                booking_code = dict[key] as! String
            }else if key == "room_type_code"{
                room_type_code = dict[key] as! String
            }else if key == "rate_plan_code"{
                rate_plan_code = dict[key] as! String
            }else if key == "booking_code"{
                booking_code = dict[key] as! String
            }else if key == "descriptions"{
                descriptions = dict[key] as? [String]
            }else if key == "rate_type_code"{
                rate_type_code = dict[key] as! String
            }else if key == "total_amount"{
                total_amount = subPriceModel(dict: dict[key] as! [String: AnyObject])
            }else{
                room_type_info = subRoomTypeModel(dict: dict[key] as! [String : AnyObject])
            }
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
    }
}

class subRateModel: NSObject{
    @objc var start_date: String = ""
    @objc var end_date: String = ""
    @objc var currency_code: String = ""
    @objc var price: Float = 0
    
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        }
}

class subRoomTypeModel: NSObject{
    @objc var room_type: String = ""
    @objc var bed_type: String = ""
    @objc var number_of_beds: String = ""
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
    }
}

class subMoreLinksModel: NSObject{
    @objc var more_rooms_at_this_hotel: hrefModel?
    init(dict:[String: AnyObject]) {
        super.init()
        more_rooms_at_this_hotel = hrefModel(dict: dict["more_rooms_at_this_hotel"] as! [String : AnyObject])
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
    }
}

class hrefModel: NSObject{
    @objc var href: String = ""
   
    init(dict:[String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
         
    }
}
