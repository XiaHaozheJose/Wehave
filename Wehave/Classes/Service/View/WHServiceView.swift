//
//  WHServiceView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import pop

let CLICK_MORE = "clickMoreButton"
class WHServiceView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    fileprivate let service_btn_count = 6
    fileprivate var serviceSubViews: [UIView] = [UIView]()
    
    // MARK: - Attribute
    @IBOutlet weak var scrollView: UIScrollView!
    
    enum NameServer: String {
        case GUIA = "Guía"
        case AVION = "Avión"
        case HOTEL = "Hotel"
        case UBICACION = "Ubicación"
        case COMENTARIO = "Comentario"
        case MAS = "Más"
        case CONTACTO = "Contactos"
        case MUSICA = "Música"
        case VIDEO = "Vídeo"
        case CAMARA = "Cámara"
    }
    
  
    //Info For Button
    private let buttonInfo: [[String:Any]] = [
        ["image":#imageLiteral(resourceName: "service_idea"),"title": "Guía", ClassName: "WHIdeaController"],
        ["image":#imageLiteral(resourceName: "service_air"),"title": "Avión", ClassName: "WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_hotel"),"title": "Hotel", ClassName: "WHHotelServiceController"],
        ["image":#imageLiteral(resourceName: "service_lbs"),"title": "Ubicación", ClassName:"WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_review"),"title": "Comentario", ClassName:"WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_more"),"title": "Más", "actionName":CLICK_MORE, ClassName:"WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_friend"),"title": "Contactos", ClassName:"WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_camera"),"title": "Cámara", ClassName: "WHCameraViewController"],
        ["image":#imageLiteral(resourceName: "service_music"),"title": "Música", ClassName:"WHNullViewController"],
        ["image":#imageLiteral(resourceName: "service_shooting"),"title": "Vídeo", ClassName: "WHVideoViewController"]
    ]
    
    private var completionBlock: ((_ clsName: String?)->())?
    
    // Initialize
    class func serviceView()->WHServiceView{
        let nib = UINib(nibName: "WHServiceView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! WHServiceView
        // From XIB default es 600x600
        view.frame = UIScreen.main.bounds
        view.setupUI()
        return view
    }
    
    // Show Current View
    func show(completion: @escaping (_ clsName: String?)->()){
        completionBlock = completion
        // 1) AddView To RootViewController
        guard let rootView = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootView.view.addSubview(self)
        
        // 2) show Animation
        showCurrentView()
    }
}

// MARK: - Setup UI
extension WHServiceView{
    private func setupUI(){
        //actualize force layout
        layoutIfNeeded()
        let rect = scrollView.bounds
        for i in 0...buttonInfo.count / 6 {
            let oneView = UIView(frame: rect.offsetBy(dx: CGFloat(i) * rect.width , dy: 0))
            addServiceButtons(v: oneView, index: i * 6)
            scrollView.addSubview(oneView)
            serviceSubViews.append(oneView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(serviceSubViews.count) * rect.width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
    }
    
    /// Add ServiceBtn
    private func addServiceButtons(v:UIView, index: Int){
        
        
        //1.) add all buttons
        for i in index..<(index + service_btn_count){
            if i >= buttonInfo.count{ break }
            // get data from buttoninfo
            let dict = buttonInfo[i]
            guard let image: UIImage = dict["image"] as? UIImage,var title: String = dict["title"] as? String
                else{ continue }
            
            switch title {
            case NameServer.GUIA.rawValue:
                title = "Guía".localized
            case NameServer.HOTEL.rawValue:
                title = "Hotel".localized
            case NameServer.AVION.rawValue:
                title = "Avión".localized
            case NameServer.UBICACION.rawValue:
                title = "Ubicación".localized
            case NameServer.CONTACTO.rawValue:
                title = "Contactos".localized
            case NameServer.COMENTARIO.rawValue:
                title = "Comentario".localized
            case NameServer.MAS.rawValue:
                title = "Más".localized
            case NameServer.CAMARA.rawValue:
                title = "Cámara".localized
            case NameServer.MUSICA.rawValue:
                title = "Música".localized
            default:
                title = "Música".localized
            }
            
            
            let button = WHServiceButton.serviceButton(image: image, title: title)
            v.addSubview(button)
            if let actionName = dict["actionName"] as? String{
                button.addTarget(self, action:Selector(actionName), for: .touchUpInside)
            }else{
                button.addTarget(self, action:#selector(clickServiceButton(btn:)), for: .touchUpInside)
            }
            button.clsName = dict[ClassName] as? String
        }
        
        //2.) set Layout
        let cols = 3
        let btnSize = CGSize(width: 100, height: 100)
        let btnMargin = (v.bounds.width - 3 * btnSize.width) / 4
        for( i,btn ) in v.subviews.enumerated(){
            let y = CGFloat(i / cols) * (v.bounds.height - btnSize.height)
            let x = CGFloat((i % 3) + 1) * btnMargin + (CGFloat(i % 3) * btnSize.width)
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
    
    // Click To RemoveView
    @IBAction func cloaseServiceview() {
        hiddenButtons()
    }
    
    // Click to back previousService View
    @IBAction func returnServiceButton() {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        
        //Hidden ReturnButton
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
        }) { _ in
            self.returnButton.isHidden = true
            self.returnButton.alpha = 1
        }
    }
    
    // Click ServiceButton
    @objc private func clickServiceButton(btn: WHServiceButton){
        let currentView = getCurrentView()
        
        for (i,button) in currentView.subviews.enumerated() {
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (button == btn) ? 2 : 0.5
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            button.pop_add(scaleAnim, forKey: nil)
            
            let alphaAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            button.pop_add(alphaAnim, forKey: nil)
            
            
            // animation completion
            if i == currentView.subviews.count - 1{
                alphaAnim.completionBlock = {_,_ in
                    self.completionBlock?(btn.clsName)
                }
            }
        }
        print("click")
    }
    
    // Click MoreButton
    @objc private func clickMoreButton(){
        // SetContentOffset
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        //Set BottomView
        let margin = scrollView.bounds.width / 6
        
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        returnButton.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Animation ServiceButton
private extension WHServiceView{
    func showCurrentView(){
        // 1> Create Animation
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        // 2> add anim to view
        pop_add(anim, forKey: nil)
        
        // 3> add Animation Buttons
        showServiceButtons()
    }
    // Animation for buttons
    func showServiceButtons(){
        scrollView.clipsToBounds = false
        // 1>
        let currentView = serviceSubViews[0]
        for (i,btn) in currentView.subviews.enumerated(){
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + scrollView.bounds.height
            anim.toValue = btn.center.y
            // Bounce Default = 4
            anim.springBounciness = 10
            // Bounce Speed  Default = 12
            anim.springSpeed = 10
            // set anim time
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
    
    // Animation To Hidden Buttons
    func hiddenButtons(){
        scrollView.clipsToBounds = true
        // 1> get currentView
        let currentView = getCurrentView()
        for (i,btn) in currentView.subviews.enumerated() {
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + scrollView.bounds.height
            // reverso 反序
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(currentView.subviews.count - i) * 0.05
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == 0{ anim.completionBlock = {_,_ in
                self.hiddenCurrentView()
                }}
        }
    }
    
    // hidden current view and removeFromSuperview
    func hiddenCurrentView(){
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = { _,_ in
            self.removeFromSuperview()
        }
    }
    
    private func getCurrentView()->UIView{
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let currentView = serviceSubViews[pageIndex]
        return currentView
    }
    
}

