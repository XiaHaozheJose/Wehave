//
//  WHReservaRoomController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/1.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
import TextFieldEffects

class WHReservaRoomController: UIViewController {
    
    // Room Model
    var roomModel: subRoomsModel?{
        didSet{
            setTopDetailView(room: roomModel!)
        }
    }
    
    // Title
    var hotelName: String = ""
    
    // hub view
    fileprivate var hub: UIView?
    fileprivate var isShow: Bool = false
    
     fileprivate let naviBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: 64))
        bar.barTintColor = ThemeColor
        return bar
    }()
    // room TopView
     fileprivate let topDetailView: WHReservaTopDetailView = {
        let top = WHReservaTopDetailView.initViewWithNib()
        top.frame.origin.y = 64
        return top
    }()
    
    // room MiddleView
    fileprivate let middleView: WHReservaMiddleDetailView = {
       let middle = WHReservaMiddleDetailView.loadFromNib()
        return middle
    }()
    
    //ScrollView
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight)
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    
    fileprivate lazy var reservaButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Reservar", for: .normal)
        btn.backgroundColor = ThemeColor
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.black, for: .highlighted)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        btn.frame = CGRect(x: 0, y: kScreenHeight - 49, width: kScreenWidth, height: 49)
        btn.addTarget(self, action: #selector(acptarReservaBtn), for: .touchUpInside)
        return btn
    }()
    fileprivate var currentTextField: UITextField?
    fileprivate var customActivity: WHActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setup()
        setNavibar()
        setScrollView()
    }
    
    
    /**
     * setup UI
     */
    private func setup(){
        view.addSubview(scrollView)
        view.addSubview(naviBar)
        view.addSubview(topDetailView)
        view.addSubview(reservaButton)
        scrollView.addSubview(middleView)
        topDetailView.delegate = self
        middleView.delegate = self
    }
    
    private func setNavibar(){
        let leftBtn = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backClick))
        leftBtn.tintColor = .black
        let rightShareBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .done, target: self, action: #selector(shareReservaDetail))
        let naviItem = UINavigationItem()
        naviItem.leftBarButtonItem = leftBtn
        naviItem.rightBarButtonItem = rightShareBtn
        naviItem.title = hotelName
        naviBar.items = [naviItem]
    }
    
    private func setTopDetailView(room: subRoomsModel){
        topDetailView.roomModel = room
    }
    
    private func setScrollView(){
        scrollView.contentInset = UIEdgeInsetsMake(topDetailView.frame.height - 100, 0, 0, 0)
        scrollView.contentSize = CGSize(width: 0, height: middleView.frame.height + (topDetailView.frame.height - 100))
    }
    
}


// MARK: -TopDetailViewDelegate
extension WHReservaRoomController: TopDetailViewDelegate{
    // show HUB
    func topDetailViewDidClick(isShow: Bool) {
        if isShow {
            hub = UIView(frame: CGRect(x: 0, y: topDetailView.frame.maxY, width: kScreenWidth,
                                       height: kScreenHeight - topDetailView.frame.height))
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(clickHubGes(tap:)))
            hub?.addGestureRecognizer(tapGes)
            hub?.backgroundColor = .black
            hub?.alpha = 0.5
            view.addSubview(hub!)
        }else{
            hub?.removeFromSuperview()
        }
    }
    
    @objc private func clickHubGes(tap:UITapGestureRecognizer){
        topDetailView.closeMiddleView()
    }
}


extension WHReservaRoomController: WHReservaMiddleDetailViewDelegate{
    func reservaMiddleDetailDidPopBoardKey(offsetY: CGFloat, duration: Double, isShowKeyBord: Bool, textField: UITextField?) {
        currentTextField = textField
        if isShowKeyBord {
            if (isShow){return}
            isShow = true
            UIView.animate(withDuration: duration, animations: {
                let hub = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth,
                                           height: kScreenHeight + offsetY))
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.clickHubGesForKeybord(tap:)))
                hub.addGestureRecognizer(tapGes)
                hub.backgroundColor = .black
                hub.alpha = 0.2
                self.view.addSubview(hub)
                self.hub = hub
            })
            self.calculateOffset(textField: textField!, offsetKeybord: offsetY)
        }else{
            isShow = false
            UIView.animate(withDuration: duration, animations: {
                self.hub?.removeFromSuperview()
            })
        }
    
    }
    
    @objc private func clickHubGesForKeybord(tap:UITapGestureRecognizer){
        currentTextField?.resignFirstResponder()
    }
    
    private func calculateOffset(textField: UITextField, offsetKeybord: CGFloat){
        let parentY = textField.superview?.frame.origin.y ?? 0
        let subY = textField.frame.origin.y
        let scrollY = scrollView.contentOffset.y
        let tfY = (parentY + subY) - scrollY
        let keyboardY = offsetKeybord - scrollY
        let x = keyboardY - tfY - 120
        print( scrollY)
        print(keyboardY - tfY)
        print(scrollY - (x + scrollY))
        scrollView.setContentOffset(CGPoint.init(x: 0, y: scrollY - (x + scrollY)), animated: true)
    }
}

// MARK: - Action : Selector
extension WHReservaRoomController{
    @objc private func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func shareReservaDetail(){
        let shareText = "We have a dream"
        let shareImage = #imageLiteral(resourceName: "JS_QRCode")
        let shareUrl = "https://github.com/XiaHaozheJose"
        let activityItems: [Any] = [shareText,shareUrl,shareImage]
        if let url = URL.init(string: shareUrl) {
            customActivity = WHActivity.init(title: "Wehave", activityImage: shareImage, activityUrl: url, activityType: "customActivity", shareText: activityItems)
            let activities = [customActivity!]
            
           let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
            if Double(UIDevice.current.systemVersion) ?? 8.0 >= 8.0 {
                activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                    if completed{
                        print("completed")
                    }
                }
            }
            self.present(activityVC, animated:true, completion: nil)

        }
    }
    
    
    @objc private func acptarReservaBtn(){
        
    }
}


