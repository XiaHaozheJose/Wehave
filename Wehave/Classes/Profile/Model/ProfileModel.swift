//
//  ProfileModel.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/30.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation

class Profile: NSObject,NSCoding{
    
    @objc var userName: String = ""
    @objc var password: String = ""
    @objc var phone: String = ""
    @objc var token: String = ""
    @objc var email: String = ""
    @objc var imageUrl: String = ""
    @objc private var goldMoney: Int = 0
    
    static var `default`: Profile = Profile()
    class func shared() -> Profile {
        return `default`
    }
    private override init(){}
    
    func keyValueForDict(dicts: [String : AnyObject]){
        setValuesForKeys(dicts)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func getGlodMoney()->Int{
        return goldMoney
    }
    
    func setGoldMoney(gold: Int){
        goldMoney = gold
    }
    
    
    func saveAccountData()->Bool{
        let isArchiver = NSKeyedArchiver.archiveRootObject(self, toFile: ("profile.plist").cacheDir())
        return isArchiver
    }
    
    func loadAccountData()->Profile?{
        if let profile = NSKeyedUnarchiver.unarchiveObject(withFile: ("profile.plist").cacheDir()) as? Profile{
        Profile.`default` = profile
        return profile
    }
        return nil
    }
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName,forKey:"userName")
        aCoder.encode(password,forKey:"password")
        aCoder.encode(phone,forKey:"phone")
        aCoder.encode(token,forKey:"token")
        aCoder.encode(email,forKey:"email")
        aCoder.encode(imageUrl,forKey:"imageUrl")
        aCoder.encode(goldMoney,forKey:"goldMoney")
    }
    
    required init?(coder aDecoder: NSCoder) {
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        password = aDecoder.decodeObject(forKey: "password") as! String
        phone = aDecoder.decodeObject(forKey: "phone") as! String
        token = aDecoder.decodeObject(forKey: "token") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String
        goldMoney = aDecoder.decodeInteger(forKey: "goldMoney")
    }
    
    // decode
    
    
    
}
