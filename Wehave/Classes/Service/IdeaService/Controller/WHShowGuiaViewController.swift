//
//  WHShowGuiaViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/7/7.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreLocation
class WHShowGuiaViewController: UIViewController {

    
    lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: kCommonMargin, y: kCommonMargin, width: 50, height: 50)
        return image
    }()

    lazy var direction: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame = CGRect(x: iconImage.frame.maxX + kCommonMargin, y: kCommonMargin, width: kScreenWidth - (iconImage.frame.maxX + kCommonMargin), height: 25)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.frame = CGRect(x: iconImage.frame.maxX + kCommonMargin, y: direction.frame.maxY + kCommonMargin, width: kScreenWidth - (iconImage.frame.maxX + kCommonMargin), height: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver".localized, style: .done, target: self, action: #selector(dismissController))
        
        
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func dismissController(){
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setWebView(guia:GuiaModel){
        view.addSubview(iconImage)
        view.addSubview(direction)
        view.addSubview(timeLabel)
        
        
        if let token = guia.user_token {
            let imagePath = WEHAVE_BASIC_LOCAL_APIs_Images + token + "_icon.png"
            iconImage.kf.setImage(with: URL(string: imagePath), placeholder: #imageLiteral(resourceName: "placeholder_icon_image"))
        }
        if let lat = guia.latitud, let log = guia.longitud{
            let location = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(log))
            LocationManager.sharedInstance.getReverseGeoCodedLocation(location: location) { (location, clp, error) in
                if let clp = clp{
                    self.direction.text = clp.locality
                }
            }
        }
        
        if let time = guia.createTime {
            timeLabel.text = time
        }
        
        if let html = guia.htmlStr{
            let web = UIWebView(frame: self.view.bounds)
            web.loadHTMLString(html, baseURL: nil)
            view.addSubview(web)
        }
        
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
